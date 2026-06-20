import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/data/services/share_service.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_decision.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/l10n/generated/app_localizations.dart';
import 'package:choose_name/ui/features/favorites/view_models/favorites_view_model.dart';
import 'package:choose_name/ui/features/favorites/views/favorites_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('adds a custom favorite name', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: NameRepository(localDatabase: database)),
          Provider.value(
            value: UserPreferencesRepository(preferences: preferences),
          ),
          Provider.value(value: const ShareService()),
        ],
        child: const _LocalizedApp(home: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('favorite_add_field')),
      'Лея',
    );
    await tester.tap(find.byKey(const ValueKey('add_favorite_button')));
    await tester.pumpAndSettle();

    expect(find.text('Лея'), findsOneWidget);

    await database.close();
  });

  testWidgets('warns when adding an already liked cached name', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    await database.upsertName(
      GenderType.male,
      const NameRecord(
        nameId: 'marko',
        name: 'Марко',
        decision: NameDecision.liked,
      ),
    );
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: NameRepository(localDatabase: database)),
          Provider.value(
            value: UserPreferencesRepository(preferences: preferences),
          ),
          Provider.value(value: const ShareService()),
        ],
        child: const _LocalizedApp(home: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('favorite_add_field')),
      'Марко',
    );
    await tester.tap(find.byKey(const ValueKey('add_favorite_button')));
    await tester.pumpAndSettle();

    expect(find.text('This name is already in favorites.'), findsOneWidget);

    await database.close();
  });

  testWidgets('warns when adding an already liked custom name', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    await database.addCustomLikedName(GenderType.male, 'Лея');
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: NameRepository(localDatabase: database)),
          Provider.value(
            value: UserPreferencesRepository(preferences: preferences),
          ),
          Provider.value(value: const ShareService()),
        ],
        child: const _LocalizedApp(home: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('favorite_add_field')),
      'Лея',
    );
    await tester.tap(find.byKey(const ValueKey('add_favorite_button')));
    await tester.pumpAndSettle();

    expect(find.text('This name is already in favorites.'), findsOneWidget);
    expect(await database.getLikedNames(GenderType.male), hasLength(1));

    await database.close();
  });

  testWidgets('warns when adding an already dismissed cached name', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    await database.upsertName(
      GenderType.male,
      const NameRecord(
        nameId: 'ivan',
        name: 'Іван',
        decision: NameDecision.disliked,
      ),
    );
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: NameRepository(localDatabase: database)),
          Provider.value(
            value: UserPreferencesRepository(preferences: preferences),
          ),
          Provider.value(value: const ShareService()),
        ],
        child: const _LocalizedApp(home: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('favorite_add_field')),
      'Іван',
    );
    await tester.tap(find.byKey(const ValueKey('add_favorite_button')));
    await tester.pumpAndSettle();

    expect(find.text('This name was already dismissed.'), findsOneWidget);

    await database.close();
  });

  testWidgets('confirms before removing a favorite', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    await database.addCustomLikedName(GenderType.male, 'Лея');
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: NameRepository(localDatabase: database)),
          Provider.value(
            value: UserPreferencesRepository(preferences: preferences),
          ),
          Provider.value(value: const ShareService()),
        ],
        child: const _LocalizedApp(home: FavoritesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('remove_favorite_Лея')));
    await tester.pumpAndSettle();
    expect(find.text('Remove this name from favorites?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Лея'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('remove_favorite_Лея')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Лея'), findsNothing);

    await database.close();
  });

  testWidgets('builds native-style Ukrainian share text', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    await database.upsertName(
      GenderType.male,
      const NameRecord(
        nameId: 'marko',
        name: 'Марко',
        decision: NameDecision.liked,
        isChosenFavorite: true,
      ),
    );
    await database.addCustomLikedName(GenderType.male, 'Лея');
    final preferences = await SharedPreferences.getInstance();
    final viewModel = FavoritesViewModel(
      nameRepository: NameRepository(localDatabase: database),
      userPreferencesRepository: UserPreferencesRepository(
        preferences: preferences,
      ),
    );

    await viewModel.load();

    expect(
      viewModel.buildShareText(),
      'Мені подобаються такі імена:\n\n'
      '❤️ Марко\n'
      '👶🏻 Лея\n'
      '\n'
      'Отримайте більше інформації про імена в додатку "Імʼя малюка" '
      '(https://apps.apple.com/ua/app/id1553686058).',
    );

    viewModel.dispose();
    await database.close();
  });
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
