import 'package:choose_name/data/repositories/user_preferences_repository.dart';
import 'package:choose_name/l10n/generated/app_localizations.dart';
import 'package:choose_name/ui/core/constants.dart';
import 'package:choose_name/ui/features/profile/views/initial_name_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
