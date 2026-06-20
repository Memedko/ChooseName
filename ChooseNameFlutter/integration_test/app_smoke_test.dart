import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/ui/core/app.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first-launch smoke covers core navigation and favorite add', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
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
    await pumpUntilFound(tester, find.byKey(const ValueKey('empty_state')));

    expect(find.byKey(const ValueKey('empty_state')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('favorites_button')));
    await pumpUntilFound(
      tester,
      find.byKey(const ValueKey('favorite_add_field')),
    );
    expect(find.byKey(const ValueKey('favorite_add_field')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('favorite_add_field')),
      'Лея',
    );
    await tester.tap(find.byKey(const ValueKey('add_favorite_button')));
    await pumpUntilFound(tester, find.text('Лея'));
    expect(find.text('Лея'), findsOneWidget);

    await tester.pageBack();
    await pumpUntilFound(tester, find.byKey(const ValueKey('empty_state')));

    await tester.tap(find.byKey(const ValueKey('profile_button')));
    await pumpUntilFound(tester, find.byKey(const ValueKey('last_name_field')));
    await tester.enterText(
      find.byKey(const ValueKey('last_name_field')),
      'Коваленко',
    );
    await tester.tap(find.byKey(const ValueKey('save_profile_button')));
    await pumpUntilFound(tester, find.text('Saved'));
    expect(find.text('Saved'), findsOneWidget);
  });
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (tester.any(finder)) {
      return;
    }
  }
  fail('Timed out waiting for $finder');
}
