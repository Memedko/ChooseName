import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../names/navigation/name_detail_route_args.dart';
import '../view_models/favorites_view_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _viewModel;
  final _controller = TextEditingController();
  final _addFocusNode = FocusNode();
  bool _addOpen = false;

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
    _addFocusNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final palette = _FavoritesPalette.forGender(_viewModel.selectedGender);
        final media = MediaQuery.of(context);
        final panelTop = media.padding.top + 10;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned(
                  left: 18,
                  right: 18,
                  top: panelTop - 12,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.backPanel,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(11),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: panelTop,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: DecoratedBox(
                      key: const ValueKey('favorites_background'),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: palette.gradient,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              _FavoritesHeader(
                                l10n: l10n,
                                palette: palette,
                                viewModel: _viewModel,
                                onClose: () => _closeScreen(context),
                                onAdd: _openAdd,
                              ),
                              Expanded(
                                child: _FavoritesList(
                                  l10n: l10n,
                                  palette: palette,
                                  viewModel: _viewModel,
                                ),
                              ),
                              if (_viewModel.favorites.isNotEmpty)
                                _ShareBar(
                                  bottomInset: media.padding.bottom,
                                  palette: palette,
                                  onShare: () => _share(context, l10n),
                                ),
                            ],
                          ),
                          if (_addOpen)
                            _AddOverlay(
                              controller: _controller,
                              focusNode: _addFocusNode,
                              palette: palette,
                              viewModel: _viewModel,
                              onClose: _closeAdd,
                              onSubmit: () => _submitAdd(context, l10n),
                              onSelectSuggestion: (name) =>
                                  _addSuggestion(context, l10n, name),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeScreen(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _openAdd() {
    setState(() => _addOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _addFocusNode.requestFocus();
      }
    });
  }

  Future<void> _closeAdd() async {
    _controller.clear();
    await _viewModel.searchForAdding('');
    if (!mounted) {
      return;
    }
    _addFocusNode.unfocus();
    setState(() => _addOpen = false);
  }

  Future<void> _submitAdd(BuildContext context, AppLocalizations l10n) async {
    final result = await _viewModel.addName(
      _enforceNameLimit(_controller, _controller.text),
    );
    if (!context.mounted) {
      return;
    }
    _showAddResult(context, l10n, result);
    if (result == AddFavoriteResult.added) {
      await _closeAdd();
    }
  }

  Future<void> _addSuggestion(
    BuildContext context,
    AppLocalizations l10n,
    NameRecord name,
  ) async {
    final result = await _viewModel.addName(name.name);
    if (!context.mounted) {
      return;
    }
    _showAddResult(context, l10n, result);
    if (result == AddFavoriteResult.added) {
      await _closeAdd();
    }
  }

  Future<void> _share(BuildContext context, AppLocalizations l10n) async {
    final result = await _viewModel.shareFavorites();
    if (context.mounted && result == ShareFavoritesResult.copied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.copied)));
    }
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

class _FavoritesPalette {
  const _FavoritesPalette({
    required this.gradient,
    required this.searchGradient,
    required this.actionColor,
    required this.backPanel,
  });

  final List<Color> gradient;
  final List<Color> searchGradient;
  final Color actionColor;
  final Color backPanel;

  static _FavoritesPalette forGender(GenderType gender) {
    if (gender.isMale) {
      return const _FavoritesPalette(
        gradient: [AppColors.boyGradientStart, AppColors.boyGradientEnd],
        searchGradient: [AppColors.boyGradientEnd, AppColors.boyGradientStart],
        actionColor: AppColors.boyLike,
        backPanel: AppColors.girlGradientStart,
      );
    }
    return const _FavoritesPalette(
      gradient: [AppColors.girlGradientStart, AppColors.girlGradientEnd],
      searchGradient: [AppColors.girlGradientEnd, AppColors.girlGradientStart],
      actionColor: AppColors.girlLike,
      backPanel: AppColors.girlGradientEnd,
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  const _FavoritesHeader({
    required this.l10n,
    required this.palette,
    required this.viewModel,
    required this.onClose,
    required this.onAdd,
  });

  final AppLocalizations l10n;
  final _FavoritesPalette palette;
  final FavoritesViewModel viewModel;
  final VoidCallback onClose;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 153,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _AssetIconButton(
              tooltip: l10n.cancel,
              asset:
                  'assets/images/icon_close_menu.imageset/icon_close_menu.png',
              onPressed: onClose,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _AssetIconButton(
              key: const ValueKey('open_add_favorite_button'),
              tooltip: l10n.add,
              asset: 'assets/images/icon_plus.imageset/icon_plus.png',
              onPressed: onAdd,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 75,
            child: _GenderTabs(l10n: l10n, viewModel: viewModel),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: _DividerLine()),
        ],
      ),
    );
  }
}

class _GenderTabs extends StatelessWidget {
  const _GenderTabs({required this.l10n, required this.viewModel});

  final AppLocalizations l10n;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('favorites_gender_toggle'),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GenderTab(
            label: l10n.maleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.male,
            onPressed: () => viewModel.selectGender(GenderType.male),
          ),
          const SizedBox(width: 40),
          _GenderTab(
            label: l10n.femaleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.female,
            onPressed: () => viewModel.selectGender(GenderType.female),
          ),
        ],
      ),
    );
  }
}

class _GenderTab extends StatelessWidget {
  const _GenderTab({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: TextButton(
        onPressed: selected ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: selected ? AppColors.mainText : AppColors.noteText,
          disabledForegroundColor: AppColors.mainText,
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({
    required this.l10n,
    required this.palette,
    required this.viewModel,
  });

  final AppLocalizations l10n;
  final _FavoritesPalette palette;
  final FavoritesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.secondaryText),
      );
    }
    if (viewModel.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            viewModel.error ?? l10n.favoritesEmpty,
            key: const ValueKey('favorites_empty'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      key: const ValueKey('favorites_list'),
      padding: EdgeInsets.zero,
      itemExtent: 66,
      itemCount: viewModel.favorites.length,
      itemBuilder: (context, index) {
        final name = viewModel.favorites[index];
        return _FavoriteTile(
          name: name,
          palette: palette,
          viewModel: viewModel,
          isLast: index == viewModel.favorites.length - 1,
        );
      },
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({
    required this.name,
    required this.palette,
    required this.viewModel,
    required this.isLast,
  });

  final NameRecord name;
  final _FavoritesPalette palette;
  final FavoritesViewModel viewModel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('favorite_${name.nameId ?? name.name}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemove(context),
      onDismissed: (_) => viewModel.remove(name),
      background: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 118,
          height: double.infinity,
          alignment: Alignment.center,
          color: Colors.white.withValues(alpha: 0.22),
          child: Text(
            AppLocalizations.of(context)!.remove,
            style: const TextStyle(
              color: AppColors.mainText,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if ((name.description?.isNotEmpty ?? false) &&
                name.nameId != null) {
              context.pushNamed(
                'details',
                extra: NameDetailRouteArgs(
                  name: name,
                  gender: viewModel.selectedGender,
                ),
              );
            }
          },
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: _DividerLine(),
              ),
              if (isLast)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _DividerLine(),
                ),
              Row(
                children: [
                  SizedBox(
                    width: 55,
                    height: 66,
                    child: IconButton(
                      onPressed: () => viewModel.choose(name),
                      padding: EdgeInsets.zero,
                      icon: Image.asset(
                        name.isChosenFavorite
                            ? 'assets/images/icon_like_on.imageset/icon_like_on.png'
                            : 'assets/images/icon_like_off.imageset/icon_like_off.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  if ((name.description?.isNotEmpty ?? false) &&
                      name.nameId != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        'assets/images/arrow_table.imageset/arrow_table.png',
                        width: 23,
                        height: 23,
                      ),
                    )
                  else
                    const SizedBox(width: 38),
                ],
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

class _ShareBar extends StatelessWidget {
  const _ShareBar({
    required this.bottomInset,
    required this.palette,
    required this.onShare,
  });

  final double bottomInset;
  final _FavoritesPalette palette;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: palette.actionColor,
      child: SizedBox(
        height: 70 + bottomInset,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: TextButton(
              key: const ValueKey('share_favorites_button'),
              onPressed: onShare,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainText,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Поділитись'),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/images/icon_share.imageset/icon_share.png',
                    width: 48,
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddOverlay extends StatelessWidget {
  const _AddOverlay({
    required this.controller,
    required this.focusNode,
    required this.palette,
    required this.viewModel,
    required this.onClose,
    required this.onSubmit,
    required this.onSelectSuggestion,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final _FavoritesPalette palette;
  final FavoritesViewModel viewModel;
  final VoidCallback onClose;
  final VoidCallback onSubmit;
  final ValueChanged<NameRecord> onSelectSuggestion;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: palette.searchGradient,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 75,
            color: Colors.white.withValues(alpha: 0.15),
            child: Row(
              children: [
                const SizedBox(width: 34),
                IconButton(
                  key: const ValueKey('add_favorite_button'),
                  onPressed: onSubmit,
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    'assets/images/icon_plus.imageset/icon_plus.png',
                    width: 24,
                    height: 34,
                    opacity: const AlwaysStoppedAnimation<double>(0.5),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    key: const ValueKey('favorite_add_field'),
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    maxLength: AppConstants.nameLimit,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                    cursorColor: AppColors.mainText,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: viewModel.searchForAdding,
                    onSubmitted: (_) => onSubmit(),
                  ),
                ),
                _AssetIconButton(
                  tooltip: AppLocalizations.of(context)!.cancel,
                  asset:
                      'assets/images/icon_no_middle.imageset/icon_no_middle.png',
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Expanded(
            child: viewModel.searchResults.isEmpty
                ? const SizedBox.shrink()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 15),
                    itemExtent: 66,
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      final name = viewModel.searchResults[index];
                      return _SearchResultTile(
                        name: name,
                        isLast: index == viewModel.searchResults.length - 1,
                        onTap: () => onSelectSuggestion(name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.name,
    required this.isLast,
    required this.onTap,
  });

  final NameRecord name;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          const Positioned(left: 0, right: 0, top: 0, child: _DividerLine()),
          if (isLast)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _DividerLine(),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.mainText.withValues(
                        alpha: name.decision.value == 0 ? 1 : 0.4,
                      ),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                if (name.decision.value != 0)
                  Image.asset(
                    name.decision.value > 0
                        ? 'assets/images/icon_yes_middle.imageset/icon_yes_middle.png'
                        : 'assets/images/icon_no_middle.imageset/icon_no_middle.png',
                    width: 35,
                    height: 35,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetIconButton extends StatelessWidget {
  const _AssetIconButton({
    required this.tooltip,
    required this.asset,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Image.asset(asset, width: 35, height: 35),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.2),
      child: const SizedBox(height: 1),
    );
  }
}
