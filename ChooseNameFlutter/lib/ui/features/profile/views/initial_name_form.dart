import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../domain/models/gender_type.dart';
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
          appBar: AppBar(title: Text(l10n.profileTitle)),
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
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      SegmentedButton<GenderType>(
                        key: const ValueKey('profile_gender_toggle'),
                        segments: [
                          ButtonSegment(
                            value: GenderType.male,
                            label: Text(l10n.maleNames),
                          ),
                          ButtonSegment(
                            value: GenderType.female,
                            label: Text(l10n.femaleNames),
                          ),
                        ],
                        selected: {_viewModel.selectedGender},
                        onSelectionChanged: (selection) async {
                          await _viewModel.selectGender(selection.single);
                          _syncControllers();
                        },
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        key: const ValueKey('last_name_field'),
                        controller: _lastNameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            AppConstants.nameLimit,
                          ),
                        ],
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: l10n.lastName,
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        key: const ValueKey('father_name_field'),
                        controller: _fatherNameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            AppConstants.nameLimit,
                          ),
                        ],
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: l10n.fatherName,
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        key: const ValueKey('save_profile_button'),
                        onPressed: () async {
                          await _viewModel.save(
                            lastName: _lastNameController.text,
                            fatherName: _fatherNameController.text,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(l10n.saved)));
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: Text(l10n.save),
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
}
