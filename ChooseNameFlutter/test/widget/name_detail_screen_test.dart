import 'package:choose_name/data/repositories/name_repository.dart';
import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/domain/models/celebrity.dart';
import 'package:choose_name/domain/models/character.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/domain/use_cases/build_name_detail_sections.dart';
import 'package:choose_name/l10n/generated/app_localizations.dart';
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
}
