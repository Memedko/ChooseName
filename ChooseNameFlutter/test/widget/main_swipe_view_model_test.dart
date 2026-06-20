import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/ui/core/constants.dart';
import 'package:choose_name/ui/features/names/view_models/main_swipe_view_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('allows card decisions even after the legacy free limit', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppConstants.shownCardsCount: AppConstants.shownCardsLimit,
    });
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.upsertName(
      GenderType.male,
      const NameRecord(nameId: 'marko', name: 'Марко'),
    );
    final preferences = await SharedPreferences.getInstance();
    final preferenceRepository = UserPreferencesRepository(
      preferences: preferences,
    );
    final viewModel = MainSwipeViewModel(
      nameRepository: NameRepository(localDatabase: database),
      userPreferencesRepository: preferenceRepository,
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();
    final didLike = await viewModel.like(viewModel.names.single);

    expect(didLike, isTrue);
    expect(
      preferenceRepository.getShownCardsCount(),
      AppConstants.shownCardsLimit + 1,
    );
    final liked = await database.getLikedNames(GenderType.male);
    expect(liked.single.nameId, 'marko');
  });
}
