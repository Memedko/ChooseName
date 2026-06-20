import 'package:flutter/foundation.dart';

import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../domain/models/gender_type.dart';

class InitialNameViewModel extends ChangeNotifier {
  InitialNameViewModel({
    required UserPreferencesRepository userPreferencesRepository,
  }) : _userPreferencesRepository = userPreferencesRepository,
       _selectedGender = userPreferencesRepository.getSelectedGender() {
    _loadSavedParts();
  }

  final UserPreferencesRepository _userPreferencesRepository;

  GenderType _selectedGender;
  String _lastName = '';
  String _fatherName = '';

  GenderType get selectedGender => _selectedGender;
  String get lastName => _lastName;
  String get fatherName => _fatherName;

  Future<void> selectGender(GenderType gender) async {
    if (_selectedGender == gender) {
      return;
    }
    _selectedGender = gender;
    await _userPreferencesRepository.setSelectedGender(gender);
    _loadSavedParts();
    notifyListeners();
  }

  Future<void> save({
    required String lastName,
    required String fatherName,
  }) async {
    _lastName = lastName.trim();
    _fatherName = fatherName.trim();
    await _userPreferencesRepository.saveNameParts(
      gender: _selectedGender,
      lastName: _lastName,
      fatherName: _fatherName,
    );
    notifyListeners();
  }

  void _loadSavedParts() {
    _lastName = _userPreferencesRepository.getLastName(_selectedGender);
    _fatherName = _userPreferencesRepository.getFatherName(_selectedGender);
  }
}
