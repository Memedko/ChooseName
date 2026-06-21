import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_record.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../view_models/main_swipe_view_model.dart';
import 'name_card.dart';

class MainSwipeScreen extends StatefulWidget {
  const MainSwipeScreen({super.key});

  @override
  State<MainSwipeScreen> createState() => _MainSwipeScreenState();
}

class _MainSwipeScreenState extends State<MainSwipeScreen> {
  final _searchController = TextEditingController();
  bool _searchOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<MainSwipeViewModel>();
    final isMale = viewModel.selectedGender.isMale;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isMale
                ? const [AppColors.boyGradientStart, AppColors.boyGradientEnd]
                : const [
                    AppColors.girlGradientStart,
                    AppColors.girlGradientEnd,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(
                searchOpen: _searchOpen,
                searchController: _searchController,
                l10n: l10n,
                onSearchChanged: viewModel.search,
                onSearchOpen: () => setState(() => _searchOpen = true),
                onSearchClose: () {
                  _searchController.clear();
                  viewModel.search('');
                  setState(() => _searchOpen = false);
                },
              ),
              _GenderTabs(l10n: l10n, viewModel: viewModel),
              Expanded(
                child: _Body(viewModel: viewModel, l10n: l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.searchOpen,
    required this.searchController,
    required this.l10n,
    required this.onSearchChanged,
    required this.onSearchOpen,
    required this.onSearchClose,
  });

  final bool searchOpen;
  final TextEditingController searchController;
  final AppLocalizations l10n;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchOpen;
  final VoidCallback onSearchClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Stack(
        children: [
          Row(
            children: [
              _TopIconButton(
                key: const ValueKey('favorites_button'),
                icon: Icons.favorite,
                onPressed: () => context.pushNamed('favorites'),
              ),
              const Spacer(),
              _TopIconButton(
                key: const ValueKey('profile_button'),
                icon: Icons.edit,
                onPressed: () => context.pushNamed('profile'),
              ),
              _TopIconButton(
                key: const ValueKey('settings_button'),
                icon: Icons.settings,
                onPressed: () => context.pushNamed('settings'),
              ),
              _TopIconButton(icon: Icons.search, onPressed: onSearchOpen),
            ],
          ),
          if (searchOpen)
            Positioned.fill(
              child: _SearchPanel(
                controller: searchController,
                l10n: l10n,
                onChanged: onSearchChanged,
                onClose: onSearchClose,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 75,
      child: IconButton(
        onPressed: onPressed,
        color: AppColors.mainText,
        iconSize: 28,
        icon: Icon(icon),
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.controller,
    required this.l10n,
    required this.onChanged,
    required this.onClose,
  });

  final TextEditingController controller;
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.15),
      child: Row(
        children: [
          const SizedBox(width: 30),
          const Icon(Icons.search, color: AppColors.noteText, size: 34),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              key: const ValueKey('main_search_field'),
              controller: controller,
              autofocus: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              onChanged: onChanged,
              cursorColor: AppColors.mainText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.secondaryText,
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.noteText,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox.square(
            dimension: 75,
            child: IconButton(
              onPressed: onClose,
              color: AppColors.secondaryText,
              icon: const Icon(Icons.cancel, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderTabs extends StatelessWidget {
  const _GenderTabs({required this.l10n, required this.viewModel});

  final AppLocalizations l10n;
  final MainSwipeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GenderButton(
            label: l10n.maleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.male,
            onPressed: () => viewModel.selectGender(GenderType.male),
          ),
          const SizedBox(width: 40),
          _GenderButton(
            label: l10n.femaleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.female,
            onPressed: () => viewModel.selectGender(GenderType.female),
          ),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
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
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: selected ? AppColors.mainText : AppColors.noteText,
          padding: EdgeInsets.zero,
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.viewModel, required this.l10n});

  final MainSwipeViewModel viewModel;
  final AppLocalizations l10n;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _controller = AppinioSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final l10n = widget.l10n;

    return Column(
      children: [
        Expanded(
          child: _cardArea(viewModel: viewModel, l10n: l10n),
        ),
        _SwipeActionBar(
          viewModel: viewModel,
          l10n: l10n,
          onDislike: _controller.swipeLeft,
          onLike: _controller.swipeRight,
        ),
      ],
    );
  }

  Widget _cardArea({
    required MainSwipeViewModel viewModel,
    required AppLocalizations l10n,
  }) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.secondaryText),
      );
    }
    if (viewModel.names.isEmpty || viewModel.hasReachedEnd) {
      return _EmptyCard(
        message: viewModel.error ?? l10n.mainEmpty,
        listAgainLabel: l10n.listAgain,
        onListAgain: viewModel.resetDisliked,
      );
    }

    return AppinioSwiper(
      key: ValueKey(
        'name_swiper_${viewModel.selectedGender.name}_${viewModel.names.length}_${viewModel.names.first.nameId ?? viewModel.names.first.name}',
      ),
      controller: _controller,
      backgroundCardCount: 0,
      swipeOptions: const SwipeOptions.symmetric(horizontal: true),
      onSwipeEnd: (previousIndex, _, activity) async {
        if (activity is! Swipe || previousIndex >= viewModel.names.length) {
          return;
        }
        final swipedName = viewModel.names[previousIndex];
        if (activity.direction == AxisDirection.right) {
          await viewModel.like(swipedName);
        } else if (activity.direction == AxisDirection.left) {
          await viewModel.dislike(swipedName);
        }
      },
      onEnd: viewModel.markDeckCompleted,
      cardCount: viewModel.names.length,
      cardBuilder: (context, index) {
        final name = viewModel.names[index];
        return NameCard(
          key: ValueKey('name_card_${name.nameId ?? name.name}'),
          name: name,
          fullName: _fullNameFor(context, name),
          detailsLabel: l10n.details,
          likedStatusLabel: l10n.likedThisName,
          dislikedStatusLabel: l10n.dislikedThisName,
          onDetails: () => context.pushNamed('details', extra: name),
        );
      },
    );
  }

  String? _fullNameFor(BuildContext context, NameRecord name) {
    final preferences = context.read<UserPreferencesRepository>();
    final gender = widget.viewModel.selectedGender;
    final fatherName = preferences.getFatherName(gender);
    final lastName = preferences.getLastName(gender);
    if (fatherName.isEmpty && lastName.isEmpty) {
      return null;
    }
    return '${name.name} $fatherName ${lastName.isEmpty ? '' : lastName}'
        .trim();
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.message,
    required this.listAgainLabel,
    required this.onListAgain,
  });

  final String message;
  final String listAgainLabel;
  final VoidCallback onListAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            key: const ValueKey('empty_state'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 70),
          SizedBox(
            width: 300,
            height: 36,
            child: OutlinedButton(
              key: const ValueKey('list_again_button'),
              onPressed: onListAgain,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondaryText,
                side: const BorderSide(color: AppColors.secondaryText),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: Text(
                listAgainLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionBar extends StatelessWidget {
  const _SwipeActionBar({
    required this.viewModel,
    required this.l10n,
    required this.onDislike,
    required this.onLike,
  });

  final MainSwipeViewModel viewModel;
  final AppLocalizations l10n;
  final VoidCallback onDislike;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final isMale = viewModel.selectedGender.isMale;
    return SizedBox(
      height: 195,
      child: Row(
        children: [
          Expanded(
            child: _SwipeActionButton(
              key: const ValueKey('dislike_button'),
              label: l10n.dislike,
              icon: Icons.close,
              color: isMale ? AppColors.boyDislike : AppColors.girlDislike,
              onPressed: onDislike,
            ),
          ),
          Expanded(
            child: _SwipeActionButton(
              key: const ValueKey('like_button'),
              label: l10n.like,
              icon: Icons.check,
              color: isMale ? AppColors.boyLike : AppColors.girlLike,
              onPressed: onLike,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.mainText, size: 64),
            const SizedBox(height: 24),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
