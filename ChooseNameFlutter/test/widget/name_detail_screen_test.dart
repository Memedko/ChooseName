import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/domain/models/celebrity.dart';
import 'package:choose_name/domain/models/character.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/domain/use_cases/build_name_detail_sections.dart';
import 'package:choose_name/l10n/generated/app_localizations.dart';
import 'package:choose_name/ui/core/app_colors.dart';
import 'package:choose_name/ui/core/constants.dart';
import 'package:choose_name/ui/features/names/views/name_detail_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('uses localized detail section headings', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'savedLastNameBoy': 'Шевченко',
      'savedFatherNameBoy': 'Іванович',
    });
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          locale: Locale('uk'),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.male,
            name: NameRecord(
              name: 'Марко',
              description: 'Значення імені',
              versions: 'Марк',
              transliteration: 'Marko',
              days: '8 травня',
              sameNames: 'Маркіян',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Марко Іванович Шевченко'), findsOneWidget);
    expect(find.text('ПІБ'), findsNothing);
    expect(find.text('Ініціали'), findsOneWidget);
    expect(find.text('Значення'), findsOneWidget);
    expect(find.text('Варіанти'), findsOneWidget);
    expect(find.text('Транслітерація'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Іменини'), findsOneWidget);
    expect(find.text('Споріднені імена'), findsOneWidget);
    expect(find.text('Full name'), findsNothing);
    expect(find.text('Versions'), findsNothing);
  });

  testWidgets('centers close arrow vertically in the close button', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          locale: Locale('uk'),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.male,
            name: NameRecord(name: 'Марко'),
          ),
        ),
      ),
    );

    final buttonCenter = tester.getCenter(
      find.byKey(const ValueKey('detail_close_button')),
    );
    final arrowCenter = tester.getCenter(
      find.byKey(const ValueKey('detail_close_arrow')),
    );

    expect((buttonCenter.dy - arrowCenter.dy).abs(), lessThanOrEqualTo(0.5));
  });

  testWidgets('centers related name and arrow vertically in the related row', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          locale: Locale('uk'),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.male,
            name: NameRecord(name: 'Марко', sameNames: 'Маркіян'),
          ),
        ),
      ),
    );

    final rowCenter = tester.getCenter(
      find.byKey(const ValueKey('detail_related_row_Маркіян')),
    );
    final nameCenter = tester.getCenter(
      find.byKey(const ValueKey('detail_related_name_Маркіян')),
    );
    final arrowCenter = tester.getCenter(
      find.byKey(const ValueKey('detail_related_arrow_Маркіян')),
    );

    expect((rowCenter.dy - nameCenter.dy).abs(), lessThanOrEqualTo(0.5));
    expect((rowCenter.dy - arrowCenter.dy).abs(), lessThanOrEqualTo(0.5));
  });

  testWidgets('renders celebrity and character image rows', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.male,
            name: NameRecord(
              name: 'Марко',
              celebrities: <Celebrity>[
                Celebrity(
                  name: 'Famous Mark',
                  photo: 'https://example.com/mark.jpg',
                  description: 'Known for carrying the name.',
                  url: 'https://example.com/mark',
                ),
              ],
              characters: <Character>[
                Character(
                  name: 'Story Mark',
                  photo: 'https://example.com/story.jpg',
                  description: 'A fictional name bearer.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('detail_person_Famous Mark')), findsOne);
    expect(find.byKey(const ValueKey('detail_person_Story Mark')), findsOne);
    expect(
      find.byKey(const ValueKey('detail_person_image_Famous Mark')),
      findsOne,
    );
    expect(find.text('Known for carrying the name.'), findsOne);
    expect(find.text('A fictional name bearer.'), findsOne);
  });

  testWidgets('shows the full famous person description', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();
    const longDescription =
        'Українська громадська та державна діячка, виконавиця, педагогиня, '
        'мисткиня, міністерка охорони здоровʼя, авторка численних ініціатив '
        'і публічних виступів, опис якої має показуватись повністю.';

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          locale: Locale('uk'),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.female,
            name: NameRecord(
              name: 'Уляна',
              celebrities: <Celebrity>[
                Celebrity(name: 'Уляна Супрун', description: longDescription),
              ],
            ),
          ),
        ),
      ),
    );

    final description = tester.widget<Text>(find.text(longDescription));

    expect(description.maxLines, isNull);
    expect(description.overflow, isNot(TextOverflow.ellipsis));
  });

  testWidgets('uses route gender instead of saved selected gender for theme', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppConstants.isMaleSelected: true,
    });
    final database = LocalNameDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: database),
          Provider(create: (_) => NameRepository(localDatabase: database)),
          Provider(
            create: (_) => UserPreferencesRepository(preferences: preferences),
          ),
          Provider(create: (_) => BuildNameDetailSections()),
        ],
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NameDetailScreen(
            gender: GenderType.female,
            name: NameRecord(name: 'Анна', description: 'Значення імені'),
          ),
        ),
      ),
    );

    final background = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('detail_background')),
    );
    final decoration = background.decoration as BoxDecoration;
    final gradient = decoration.gradient as LinearGradient;

    expect(gradient.colors, <Color>[
      AppColors.girlGradientStart,
      AppColors.girlGradientEnd,
    ]);
  });
}
