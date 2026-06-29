import 'dart:ui';

import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_decision.dart';
import 'package:choose_name/domain/models/name_record.dart';
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

  testWidgets('advances main picker after liking a name from details', (
    tester,
  ) async {
    final database = await _pumpPickerWithTwoNames(tester);
    await _chooseFromDetails(tester, 'detail_like_button');

    expect(find.byKey(const ValueKey('name_card_marko')), findsNothing);
    expect(find.byKey(const ValueKey('name_card_andrii')), findsOneWidget);

    final liked = await database.getLikedNames(GenderType.male);
    expect(liked.single.nameId, 'marko');
    final marko = await database.findNameByExactText(GenderType.male, 'Марко');
    expect(marko?.decision, NameDecision.liked);
    final unseen = await database.getUnseenNames(GenderType.male);
    expect(unseen.map((name) => name.nameId), <String?>['andrii']);
  });

  testWidgets('advances main picker after disliking a name from details', (
    tester,
  ) async {
    final database = await _pumpPickerWithTwoNames(tester);
    await _chooseFromDetails(tester, 'detail_dislike_button');

    expect(find.byKey(const ValueKey('name_card_marko')), findsNothing);
    expect(find.byKey(const ValueKey('name_card_andrii')), findsOneWidget);

    final marko = await database.findNameByExactText(GenderType.male, 'Марко');
    expect(marko?.decision, NameDecision.disliked);
    final unseen = await database.getUnseenNames(GenderType.male);
    expect(unseen.map((name) => name.nameId), <String?>['andrii']);
  });

  testWidgets('opens and closes the main search panel', (tester) async {
    await _pumpPickerWithTwoNames(tester);

    expect(find.byKey(const ValueKey('main_search_field')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('open_search_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const ValueKey('main_search_panel')), findsOneWidget);
    expect(find.byKey(const ValueKey('main_search_field')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('main_search_field')),
      'Андрій',
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const ValueKey('name_card_marko')), findsNothing);
    expect(find.byKey(const ValueKey('name_card_andrii')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('close_search_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const ValueKey('main_search_field')), findsNothing);
  });

  testWidgets('closes the main search panel when gender changes', (
    tester,
  ) async {
    await _pumpPickerWithTwoNames(tester);

    await tester.tap(find.byKey(const ValueKey('open_search_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));
    expect(find.byKey(const ValueKey('main_search_field')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('female_gender_tab')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const ValueKey('main_search_field')), findsNothing);
  });

  testWidgets('hides swipe actions while search keyboard is visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await _pumpPickerWithTwoNames(tester);

    expect(find.byKey(const ValueKey('swipe_action_bar')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('open_search_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));
    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    await tester.pump();

    expect(find.byKey(const ValueKey('main_search_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('swipe_action_bar')), findsNothing);
  });
}

Future<LocalNameDatabase> _pumpPickerWithTwoNames(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
  addTearDown(database.close);
  await database.upsertName(
    GenderType.male,
    const NameRecord(
      nameId: 'marko',
      name: 'Марко',
      description: 'Значення імені',
    ),
  );
  await database.upsertName(
    GenderType.male,
    const NameRecord(
      nameId: 'andrii',
      name: 'Андрій',
      description: 'Значення імені',
    ),
  );
  final preferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ChooseNameApp(
      nameRepository: NameRepository(localDatabase: database),
      userPreferencesRepository: UserPreferencesRepository(
        preferences: preferences,
      ),
      localNameDatabase: database,
      startupSplashDuration: Duration.zero,
    ),
  );
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey('name_card_marko')), findsOneWidget);
  return database;
}

Future<void> _chooseFromDetails(WidgetTester tester, String buttonKey) async {
  await tester.tap(find.byKey(const ValueKey('name_card_marko')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(buttonKey)));
  await tester.pumpAndSettle();
}
