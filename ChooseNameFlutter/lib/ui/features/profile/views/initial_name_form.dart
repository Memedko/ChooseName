import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../../../core/constants.dart';
import '../view_models/initial_name_view_model.dart';

class InitialNameForm extends StatefulWidget {
  const InitialNameForm({super.key});

  @override
  State<InitialNameForm> createState() => _InitialNameFormState();
}

class _InitialNameFormState extends State<InitialNameForm> {
  late final InitialNameViewModel _viewModel;
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _lastNameFocusNode = FocusNode();
  final _fatherNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = InitialNameViewModel(
      userPreferencesRepository: context.read<UserPreferencesRepository>(),
    );
    _syncControllers();
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _lastNameFocusNode.dispose();
    _fatherNameFocusNode.dispose();
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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: DecoratedBox(
              key: const ValueKey('profile_background'),
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
                bottom: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: FocusScope.of(context).unfocus,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(32, 62, 32, 36),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _ProfileHeader(title: l10n.detailFullName),
                                  const SizedBox(height: 60),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    child: _ProfileInstruction(),
                                  ),
                                  const SizedBox(height: 82),
                                  _ProfileTextField(
                                    key: const ValueKey('last_name_field'),
                                    controller: _lastNameController,
                                    focusNode: _lastNameFocusNode,
                                    nextFocusNode: _fatherNameFocusNode,
                                    hintText: l10n.lastName,
                                    textInputAction: TextInputAction.next,
                                    autofocus: true,
                                  ),
                                  const SizedBox(height: 54),
                                  _ProfileTextField(
                                    key: const ValueKey('father_name_field'),
                                    controller: _fatherNameController,
                                    focusNode: _fatherNameFocusNode,
                                    hintText: l10n.fatherName,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _ProfileActionBar(
                        isMale: isMale,
                        closeLabel: l10n.detailClose,
                        saveLabel: l10n.save,
                        onClose: () => _close(context),
                        onSave: () => _save(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _syncControllers() {
    _lastNameController.text = _viewModel.lastName;
    _fatherNameController.text = _viewModel.fatherName;
  }

  Future<void> _save(BuildContext context) async {
    await _viewModel.save(
      lastName: _lastNameController.text,
      fatherName: _fatherNameController.text,
    );
    if (context.mounted) {
      await _close(context);
    }
  }

  Future<void> _close(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.of(context).maybePop();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('profile_header'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/icon_edit.imageset/icon_edit.png',
          key: const ValueKey('profile_header_icon'),
          width: 35,
          height: 35,
        ),
        const SizedBox(width: 15),
        Text(
          title,
          key: const ValueKey('profile_title'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.mainText,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _ProfileInstruction extends StatelessWidget {
  const _ProfileInstruction();

  static const text =
      'Введіть прізвище та по батькові, щоб побачити, '
      'як імʼя поєднується з ними.';

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: const ValueKey('profile_instruction'),
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.noteText,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.textInputAction,
    this.nextFocusNode,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String hintText;
  final TextInputAction textInputAction;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: AppColors.secondaryText,
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 1.15,
    );
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.secondaryText, width: 1.2),
    );

    return SizedBox(
      height: 72,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(AppConstants.nameLimit),
        ],
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        textInputAction: textInputAction,
        onSubmitted: (_) {
          final next = nextFocusNode;
          if (next == null) {
            focusNode.unfocus();
          } else {
            next.requestFocus();
          }
        },
        cursorColor: AppColors.mainText,
        cursorHeight: 28,
        style: textStyle,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle?.copyWith(color: AppColors.noteText),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(
              color: AppColors.secondaryText,
              width: 1.4,
            ),
          ),
          contentPadding: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }
}

class _ProfileActionBar extends StatelessWidget {
  const _ProfileActionBar({
    required this.isMale,
    required this.closeLabel,
    required this.saveLabel,
    required this.onClose,
    required this.onSave,
  });

  final bool isMale;
  final String closeLabel;
  final String saveLabel;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('profile_action_bar'),
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: _ProfileActionButton(
              key: const ValueKey('close_profile_button'),
              label: closeLabel,
              color: isMale ? AppColors.boyDislike : AppColors.girlDislike,
              onPressed: onClose,
            ),
          ),
          Expanded(
            child: _ProfileActionButton(
              key: const ValueKey('save_profile_button'),
              label: saveLabel,
              color: isMale ? AppColors.boyLike : AppColors.girlLike,
              onPressed: onSave,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
