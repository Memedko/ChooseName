import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('stores selected gender, name parts, and shown-card count', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final repository = UserPreferencesRepository(preferences: preferences);

    await repository.setSelectedGender(GenderType.female);
    await repository.saveNameParts(
      gender: GenderType.female,
      lastName: 'Коваленко',
      fatherName: 'Іванівна',
    );
    await repository.incrementShownCardsCount();
    await repository.incrementShownCardsCount();

    expect(repository.getSelectedGender(), GenderType.female);
    expect(repository.getLastName(GenderType.female), 'Коваленко');
    expect(repository.getFatherName(GenderType.female), 'Іванівна');
    expect(repository.getShownCardsCount(), 2);
  });

  test(
    'clearUserData resets profile fields, selected gender, and card count',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final preferences = await SharedPreferences.getInstance();
      final repository = UserPreferencesRepository(preferences: preferences);

      await repository.setSelectedGender(GenderType.female);
      await repository.saveNameParts(
        gender: GenderType.female,
        lastName: 'Коваленко',
        fatherName: 'Іванівна',
      );
      await repository.incrementShownCardsCount();

      await repository.clearUserData();

      expect(repository.getSelectedGender(), GenderType.male);
      expect(repository.getLastName(GenderType.female), isEmpty);
      expect(repository.getFatherName(GenderType.female), isEmpty);
      expect(repository.getShownCardsCount(), 0);
    },
  );
}
