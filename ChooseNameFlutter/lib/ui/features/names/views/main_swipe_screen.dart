import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_decision.dart';
import '../../../../domain/models/name_record.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../navigation/name_detail_route_args.dart';
import '../view_models/main_swipe_view_model.dart';
import 'name_card.dart';

const _searchPanelOpenDuration = Duration(milliseconds: 240);
const _searchPanelCloseDuration = Duration(milliseconds: 200);

class MainSwipeScreen extends StatefulWidget {
  const MainSwipeScreen({super.key});

  @override
  State<MainSwipeScreen> createState() => _MainSwipeScreenState();
}

class _MainSwipeScreenState extends State<MainSwipeScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _searchFieldKey = GlobalKey();
  bool _searchOpen = false;
  bool _searchInputActive = false;
  int _searchFocusRequest = 0;

  @override
  void dispose() {
    _searchFocusRequest++;
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    if (_searchOpen) {
      final request = ++_searchFocusRequest;
      if (!_searchInputActive) {
        setState(() => _searchInputActive = true);
        _showSearchKeyboardWhenReady(request);
      } else {
        _requestSearchKeyboard();
      }
      return;
    }
    setState(() {
      _searchOpen = true;
      _searchInputActive = false;
    });
    final request = ++_searchFocusRequest;
    Future<void>.delayed(_searchPanelOpenDuration, () {
      if (!mounted || !_searchOpen || request != _searchFocusRequest) {
        return;
      }
      setState(() => _searchInputActive = true);
      _showSearchKeyboardWhenReady(request);
    });
  }

  void _showSearchKeyboardWhenReady(int request) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            !_searchOpen ||
            !_searchInputActive ||
            request != _searchFocusRequest) {
          return;
        }
        _requestSearchKeyboard();
      });
    });
  }

  void _requestSearchKeyboard() {
    final fieldContext = _searchFieldKey.currentContext;
    final editableText = fieldContext == null
        ? null
        : _findEditableTextState(fieldContext as Element);
    if (editableText != null) {
      editableText.requestKeyboard();
      return;
    }
    _searchFocusNode.requestFocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  EditableTextState? _findEditableTextState(Element root) {
    EditableTextState? result;
    void visitor(Element element) {
      if (result != null) {
        return;
      }
      if (element is StatefulElement && element.state is EditableTextState) {
        result = element.state as EditableTextState;
        return;
      }
      element.visitChildren(visitor);
    }

    root.visitChildren(visitor);
    return result;
  }

  void _closeSearch(MainSwipeViewModel viewModel) {
    final hadSearchText = _searchController.text.trim().isNotEmpty;
    _searchFocusRequest++;
    _searchFocusNode.unfocus();
    _searchController.clear();
    if (_searchOpen) {
      setState(() {
        _searchOpen = false;
        _searchInputActive = false;
      });
    }
    if (hadSearchText) {
      viewModel.search('');
    }
  }

  void _selectGender(MainSwipeViewModel viewModel, GenderType gender) {
    if (viewModel.selectedGender == gender) {
      return;
    }
    _searchFocusRequest++;
    _searchFocusNode.unfocus();
    _searchController.clear();
    if (_searchOpen) {
      setState(() {
        _searchOpen = false;
        _searchInputActive = false;
      });
    }
    viewModel.selectGender(gender);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<MainSwipeViewModel>();
    final isMale = viewModel.selectedGender.isMale;
    final compactForSearch =
        _searchOpen && MediaQuery.viewInsetsOf(context).bottom > 0;

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
                isMale: isMale,
                searchOpen: _searchOpen,
                searchInputActive: _searchInputActive,
                searchFieldKey: _searchFieldKey,
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                onSearchChanged: viewModel.search,
                onSearchOpen: _openSearch,
                onSearchClose: () => _closeSearch(viewModel),
              ),
              _GenderTabs(
                l10n: l10n,
                viewModel: viewModel,
                onGenderSelected: (gender) => _selectGender(viewModel, gender),
              ),
              Expanded(
                child: _Body(
                  viewModel: viewModel,
                  l10n: l10n,
                  compactForSearch: compactForSearch,
                ),
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
    required this.isMale,
    required this.searchOpen,
    required this.searchInputActive,
    required this.searchFieldKey,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onSearchOpen,
    required this.onSearchClose,
  });

  final bool isMale;
  final bool searchOpen;
  final bool searchInputActive;
  final GlobalKey searchFieldKey;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchOpen;
  final VoidCallback onSearchClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: searchOpen,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: searchOpen ? 0 : 1,
              child: Row(
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
                  _TopIconButton(
                    key: const ValueKey('open_search_button'),
                    icon: Icons.search,
                    onPressed: onSearchOpen,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              key: const ValueKey('main_search_switcher'),
              duration: _searchPanelOpenDuration,
              reverseDuration: _searchPanelCloseDuration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    for (final child in previousChildren)
                      Positioned.fill(child: child),
                    if (currentChild != null)
                      Positioned.fill(child: currentChild),
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation);
                return ClipRect(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: searchOpen
                  ? _SearchPanel(
                      key: const ValueKey('main_search_panel'),
                      isMale: isMale,
                      inputActive: searchInputActive,
                      fieldKey: searchFieldKey,
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: onSearchChanged,
                      onClose: onSearchClose,
                    )
                  : const SizedBox.shrink(key: ValueKey('main_search_closed')),
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
    required this.isMale,
    required this.inputActive,
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClose,
    super.key,
  });

  static const _boySearchBar = Color(0xFF6A3A97);
  static const _girlSearchBar = Color(0xFF983374);

  final bool isMale;
  final bool inputActive;
  final GlobalKey fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isMale ? _boySearchBar : _girlSearchBar,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 34),
          const Icon(
            Icons.search,
            key: ValueKey('main_search_icon'),
            color: AppColors.noteText,
            size: 45,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: SizedBox(
              height: 56,
              child: KeyedSubtree(
                key: const ValueKey('main_search_field'),
                child: KeyedSubtree(
                  key: fieldKey,
                  child: TextField(
                    key: ValueKey(
                      'main_search_text_field_${inputActive ? 'active' : 'idle'}',
                    ),
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: inputActive,
                    autocorrect: false,
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.words,
                    onChanged: onChanged,
                    cursorColor: AppColors.mainText,
                    cursorHeight: 46,
                    cursorWidth: 2.5,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.mainText,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 86,
            height: 90,
            child: IconButton(
              key: const ValueKey('close_search_button'),
              onPressed: onClose,
              color: AppColors.secondaryText,
              icon: const Icon(Icons.close, size: 43),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderTabs extends StatelessWidget {
  const _GenderTabs({
    required this.l10n,
    required this.viewModel,
    required this.onGenderSelected,
  });

  final AppLocalizations l10n;
  final MainSwipeViewModel viewModel;
  final ValueChanged<GenderType> onGenderSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GenderButton(
            key: const ValueKey('male_gender_tab'),
            label: l10n.maleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.male,
            onPressed: () => onGenderSelected(GenderType.male),
          ),
          const SizedBox(width: 40),
          _GenderButton(
            key: const ValueKey('female_gender_tab'),
            label: l10n.femaleNames.toUpperCase(),
            selected: viewModel.selectedGender == GenderType.female,
            onPressed: () => onGenderSelected(GenderType.female),
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
    super.key,
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
  const _Body({
    required this.viewModel,
    required this.l10n,
    required this.compactForSearch,
  });

  final MainSwipeViewModel viewModel;
  final AppLocalizations l10n;
  final bool compactForSearch;

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
        if (!widget.compactForSearch)
          _SwipeActionBar(
            key: const ValueKey('swipe_action_bar'),
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
          compact: widget.compactForSearch,
          fullName: _fullNameFor(context, name),
          detailsLabel: l10n.details,
          likedStatusLabel: l10n.likedThisName,
          dislikedStatusLabel: l10n.dislikedThisName,
          onDetails: () =>
              _openDetails(context, name, viewModel.selectedGender),
        );
      },
    );
  }

  Future<void> _openDetails(
    BuildContext context,
    NameRecord name,
    GenderType gender,
  ) async {
    final decision = await context.pushNamed<NameDecision>(
      'details',
      extra: NameDetailRouteArgs(
        name: name,
        gender: gender,
        returnDecisionToCaller: true,
      ),
    );
    if (!mounted ||
        widget.viewModel.selectedGender != gender ||
        _controller.cardIndex == null) {
      return;
    }

    switch (decision) {
      case NameDecision.liked:
        await _controller.swipeRight();
      case NameDecision.disliked:
        await _controller.swipeLeft();
      case NameDecision.neutral:
      case null:
        return;
    }
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
    super.key,
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
