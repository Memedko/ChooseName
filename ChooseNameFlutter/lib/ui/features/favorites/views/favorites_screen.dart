import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/name_repository.dart';
import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../data/services/share_service.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_record.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../../../core/constants.dart';
import '../view_models/favorites_view_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _viewModel;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = FavoritesViewModel(
      nameRepository: context.read<NameRepository>(),
      userPreferencesRepository: context.read<UserPreferencesRepository>(),
      shareService: context.read<ShareService>(),
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isMale = _viewModel.selectedGender.isMale;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.favoritesTitle),
            actions: [
              IconButton(
                key: const ValueKey('share_favorites_button'),
                tooltip: l10n.copyFavorites,
                onPressed: _viewModel.favorites.isEmpty
                    ? null
                    : () async {
                        final result = await _viewModel.shareFavorites();
                        if (context.mounted &&
                            result == ShareFavoritesResult.copied) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(l10n.copied)));
                        }
                      },
                icon: const Icon(Icons.ios_share),
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isMale
                    ? const [
                        AppColors.boyGradientStart,
                        AppColors.boyGradientEnd,
                      ]
                    : const [
                        AppColors.girlGradientStart,
                        AppColors.girlGradientEnd,
                      ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _GenderToggle(l10n: l10n, viewModel: _viewModel),
                        const SizedBox(height: 14),
                        _AddNameField(
                          controller: _controller,
                          l10n: l10n,
                          viewModel: _viewModel,
                        ),
                        const SizedBox(height: 12),
                        if (_viewModel.searchResults.isNotEmpty)
                          _SearchResults(viewModel: _viewModel),
                        Expanded(
                          child: _FavoritesList(
                            l10n: l10n,
                            viewModel: _viewModel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GenderToggle extends StatelessWidget {
  const _GenderToggle({required this.l10n, required this.viewModel});

  final AppLocalizations l10n;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<GenderType>(
      key: const ValueKey('favorites_gender_toggle'),
      segments: [
        ButtonSegment(value: GenderType.male, label: Text(l10n.maleNames)),
        ButtonSegment(value: GenderType.female, label: Text(l10n.femaleNames)),
      ],
      selected: {viewModel.selectedGender},
      onSelectionChanged: (selection) =>
          viewModel.selectGender(selection.single),
    );
  }
}

class _AddNameField extends StatelessWidget {
  const _AddNameField({
    required this.controller,
    required this.l10n,
    required this.viewModel,
  });

  final TextEditingController controller;
  final AppLocalizations l10n;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      key: const ValueKey('favorite_add_field'),
      controller: controller,
      hintText: l10n.addFavoriteHint,
      leading: const Icon(Icons.search),
      trailing: [
        IconButton(
          key: const ValueKey('add_favorite_button'),
          tooltip: l10n.add,
          onPressed: () async {
            final result = await viewModel.addName(
              _enforceNameLimit(controller, controller.text),
            );
            if (context.mounted) {
              _showAddResult(context, l10n, result);
            }
            if (result == AddFavoriteResult.added) {
              controller.clear();
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
      onChanged: (value) {
        final limited = _enforceNameLimit(controller, value);
        viewModel.searchForAdding(limited);
      },
      onSubmitted: (value) async {
        final result = await viewModel.addName(
          _enforceNameLimit(controller, value),
        );
        if (context.mounted) {
          _showAddResult(context, l10n, result);
        }
        if (result == AddFavoriteResult.added) {
          controller.clear();
        }
      },
    );
  }

  String _enforceNameLimit(TextEditingController controller, String value) {
    if (value.length <= AppConstants.nameLimit) {
      return value;
    }
    final limited = value.substring(0, AppConstants.nameLimit);
    controller.value = TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
    return limited;
  }

  void _showAddResult(
    BuildContext context,
    AppLocalizations l10n,
    AddFavoriteResult? result,
  ) {
    final message = switch (result) {
      AddFavoriteResult.alreadyLiked => l10n.nameAlreadyLiked,
      AddFavoriteResult.alreadyDisliked => l10n.nameAlreadyDisliked,
      AddFavoriteResult.added => null,
      null => null,
    };
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.viewModel});

  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: viewModel.searchResults
            .take(4)
            .map(
              (name) => ListTile(
                dense: true,
                title: Text(name.name),
                trailing: const Icon(Icons.add),
                onTap: () async {
                  final result = await viewModel.addName(name.name);
                  if (context.mounted && result != AddFavoriteResult.added) {
                    final l10n = AppLocalizations.of(context)!;
                    final message = result == AddFavoriteResult.alreadyLiked
                        ? l10n.nameAlreadyLiked
                        : l10n.nameAlreadyDisliked;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({required this.l10n, required this.viewModel});

  final AppLocalizations l10n;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mainText),
      );
    }
    if (viewModel.favorites.isEmpty) {
      return Center(
        child: Text(
          viewModel.error ?? l10n.favoritesEmpty,
          key: const ValueKey('favorites_empty'),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.mainText),
        ),
      );
    }
    return ListView.separated(
      key: const ValueKey('favorites_list'),
      itemCount: viewModel.favorites.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final name = viewModel.favorites[index];
        return _FavoriteTile(name: name, viewModel: viewModel);
      },
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.name, required this.viewModel});

  final NameRecord name;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('favorite_${name.nameId ?? name.name}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemove(context),
      onDismissed: (_) => viewModel.remove(name),
      background: const ColoredBox(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 18),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Material(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Text(name.name),
          leading: IconButton(
            onPressed: () => viewModel.choose(name),
            icon: Icon(
              name.isChosenFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.mainColor,
            ),
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              if ((name.description?.isNotEmpty ?? false) &&
                  name.nameId != null)
                IconButton(
                  onPressed: () => context.pushNamed('details', extra: name),
                  icon: const Icon(Icons.chevron_right),
                ),
              IconButton(
                key: ValueKey('remove_favorite_${name.nameId ?? name.name}'),
                onPressed: () async {
                  final confirmed = await _confirmRemove(context);
                  if (confirmed) {
                    await viewModel.remove(name);
                  }
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmRemove(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeFavoriteTitle),
        content: Text(l10n.removeFavoriteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
