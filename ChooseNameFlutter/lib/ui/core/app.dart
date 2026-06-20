import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/name_repository.dart';
import '../../data/repositories/user_preferences_repository.dart';
import '../../data/services/analytics_service.dart';
import '../../data/services/local_name_database.dart';
import '../../data/services/share_service.dart';
import '../../domain/use_cases/build_name_detail_sections.dart';
import '../../l10n/generated/app_localizations.dart';
import '../features/names/view_models/main_swipe_view_model.dart';
import 'app_colors.dart';
import 'router.dart';

class ChooseNameApp extends StatelessWidget {
  ChooseNameApp({
    required this.nameRepository,
    required this.userPreferencesRepository,
    required this.localNameDatabase,
    AnalyticsService? analyticsService,
    super.key,
  }) : analyticsService = analyticsService ?? AnalyticsService.disabled();

  final NameRepository nameRepository;
  final UserPreferencesRepository userPreferencesRepository;
  final LocalNameDatabase localNameDatabase;
  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    final router = createRouter(observers: analyticsService.routeObservers);

    return MultiProvider(
      providers: [
        Provider.value(value: localNameDatabase),
        Provider.value(value: nameRepository),
        Provider.value(value: userPreferencesRepository),
        Provider.value(value: analyticsService),
        Provider(create: (_) => const ShareService()),
        Provider(create: (_) => BuildNameDetailSections()),
        ChangeNotifierProvider(
          create: (_) => MainSwipeViewModel(
            nameRepository: nameRepository,
            userPreferencesRepository: userPreferencesRepository,
            analyticsService: analyticsService,
          )..load(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Імʼя малюка',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'MontserratAlternates',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.mainColor,
            brightness: Brightness.light,
          ),
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
