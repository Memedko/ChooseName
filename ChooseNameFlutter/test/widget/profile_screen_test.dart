import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/l10n/generated/app_localizations.dart';
import 'package:choose_name/ui/core/app_colors.dart';
import 'package:choose_name/ui/core/constants.dart';
import 'package:choose_name/ui/features/profile/views/initial_name_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders male profile form with native-style colors', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppConstants.isMaleSelected: true,
    });
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      Provider(
        create: (_) => UserPreferencesRepository(preferences: preferences),
        child: const _LocalizedApp(home: InitialNameForm()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsNothing);
    expect(find.byKey(const ValueKey('profile_gender_toggle')), findsNothing);
    expect(find.byKey(const ValueKey('profile_header_icon')), findsOneWidget);
    expect(find.text('ПІБ'), findsOneWidget);
    expect(
      find.text(
        'Введіть прізвище та по батькові, щоб побачити, '
        'як імʼя поєднується з ними.',
      ),
      findsOneWidget,
    );
    expect(find.text('Прізвище'), findsOneWidget);
    expect(find.text('По батькові'), findsOneWidget);
    expect(find.text('Закрити'), findsOneWidget);
    expect(find.text('Зберегти'), findsOneWidget);
    _expectProfileTheme(
      backgroundColors: const [
        AppColors.boyGradientStart,
        AppColors.boyGradientEnd,
      ],
      closeColor: AppColors.boyDislike,
      saveColor: AppColors.boyLike,
      tester: tester,
    );
  });

  testWidgets('renders female profile form with native-style colors', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppConstants.isMaleSelected: false,
    });
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      Provider(
        create: (_) => UserPreferencesRepository(preferences: preferences),
        child: const _LocalizedApp(home: InitialNameForm()),
      ),
    );
    await tester.pumpAndSettle();

    _expectProfileTheme(
      backgroundColors: const [
        AppColors.girlGradientStart,
        AppColors.girlGradientEnd,
      ],
      closeColor: AppColors.girlDislike,
      saveColor: AppColors.girlLike,
      tester: tester,
    );
  });

  testWidgets('saves selected profile name parts', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      Provider(
        create: (_) => UserPreferencesRepository(preferences: preferences),
        child: const _LocalizedApp(home: InitialNameForm()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('last_name_field')),
      'Коваленко',
    );
    await tester.enterText(
      find.byKey(const ValueKey('father_name_field')),
      'Іванович',
    );
    await tester.tap(find.byKey(const ValueKey('save_profile_button')));
    await tester.pumpAndSettle();

    expect(preferences.getString(AppConstants.savedMaleLastName), 'Коваленко');
    expect(preferences.getString(AppConstants.savedMaleFatherName), 'Іванович');
  });

  testWidgets('saves female profile name parts for selected female gender', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppConstants.isMaleSelected: false,
    });
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      Provider(
        create: (_) => UserPreferencesRepository(preferences: preferences),
        child: const _LocalizedApp(home: InitialNameForm()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('last_name_field')),
      'Коваленко',
    );
    await tester.enterText(
      find.byKey(const ValueKey('father_name_field')),
      'Іванівна',
    );
    await tester.tap(find.byKey(const ValueKey('save_profile_button')));
    await tester.pumpAndSettle();

    expect(
      preferences.getString(AppConstants.savedFemaleLastName),
      'Коваленко',
    );
    expect(
      preferences.getString(AppConstants.savedFemaleFatherName),
      'Іванівна',
    );
    expect(preferences.getString(AppConstants.savedMaleLastName), isNull);
  });

  testWidgets('limits profile fields to native name limit', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final longName = 'А' * (AppConstants.nameLimit + 10);

    await tester.pumpWidget(
      Provider(
        create: (_) => UserPreferencesRepository(preferences: preferences),
        child: const _LocalizedApp(home: InitialNameForm()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('last_name_field')),
      longName,
    );
    await tester.tap(find.byKey(const ValueKey('save_profile_button')));
    await tester.pumpAndSettle();

    expect(
      preferences.getString(AppConstants.savedMaleLastName)?.length,
      AppConstants.nameLimit,
    );
  });
}

void _expectProfileTheme({
  required WidgetTester tester,
  required List<Color> backgroundColors,
  required Color closeColor,
  required Color saveColor,
}) {
  final background = tester.widget<DecoratedBox>(
    find.byKey(const ValueKey('profile_background')),
  );
  final decoration = background.decoration as BoxDecoration;
  final gradient = decoration.gradient as LinearGradient;
  expect(gradient.colors, backgroundColors);

  expect(_actionButtonColor(tester, 'close_profile_button'), closeColor);
  expect(_actionButtonColor(tester, 'save_profile_button'), saveColor);
}

Color? _actionButtonColor(WidgetTester tester, String key) {
  final material = tester.widget<Material>(
    find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.byType(Material),
    ),
  );
  return material.color;
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
