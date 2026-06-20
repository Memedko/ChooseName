import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/ui/core/app.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows empty picker state from repository-backed app shell', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ChooseNameApp(
        nameRepository: NameRepository(localDatabase: database),
        userPreferencesRepository: UserPreferencesRepository(
          preferences: preferences,
        ),
        localNameDatabase: database,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('empty_state')), findsOneWidget);

    await database.close();
  });
}
