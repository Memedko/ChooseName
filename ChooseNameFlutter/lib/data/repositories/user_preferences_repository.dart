import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/gender_type.dart';
import '../../ui/core/constants.dart';

class UserPreferencesRepository {
  UserPreferencesRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  GenderType getSelectedGender() {
    return _preferences.getBool(AppConstants.isMaleSelected) ?? true
        ? GenderType.male
        : GenderType.female;
  }

  Future<void> setSelectedGender(GenderType gender) {
    return _preferences.setBool(AppConstants.isMaleSelected, gender.isMale);
  }

  String getLastName(GenderType gender) {
    return _preferences.getString(
          gender.isMale
              ? AppConstants.savedMaleLastName
              : AppConstants.savedFemaleLastName,
        ) ??
        '';
  }

  String getFatherName(GenderType gender) {
    return _preferences.getString(
          gender.isMale
              ? AppConstants.savedMaleFatherName
              : AppConstants.savedFemaleFatherName,
        ) ??
        '';
  }

  Future<void> saveNameParts({
    required GenderType gender,
    required String lastName,
    required String fatherName,
  }) async {
    await _preferences.setString(
      gender.isMale
          ? AppConstants.savedMaleLastName
          : AppConstants.savedFemaleLastName,
      lastName,
    );
    await _preferences.setString(
      gender.isMale
          ? AppConstants.savedMaleFatherName
          : AppConstants.savedFemaleFatherName,
      fatherName,
    );
  }

  int getShownCardsCount() {
    return _preferences.getInt(AppConstants.shownCardsCount) ?? 0;
  }

  Future<int> incrementShownCardsCount() async {
    final next = getShownCardsCount() + 1;
    await _preferences.setInt(AppConstants.shownCardsCount, next);
    return next;
  }

  Future<void> clearUserData() async {
    await _preferences.remove(AppConstants.savedMaleLastName);
    await _preferences.remove(AppConstants.savedMaleFatherName);
    await _preferences.remove(AppConstants.savedFemaleLastName);
    await _preferences.remove(AppConstants.savedFemaleFatherName);
    await _preferences.remove(AppConstants.shownCardsCount);
    await _preferences.remove(AppConstants.isMaleSelected);
  }
}
