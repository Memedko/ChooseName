import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/name_repository.dart';
import 'data/repositories/user_preferences_repository.dart';
import 'data/services/analytics_service.dart';
import 'data/services/firebase_bootstrap.dart';
import 'data/services/firestore_name_service.dart';
import 'data/services/local_name_database.dart';
import 'ui/core/app.dart';
import 'ui/features/splash/views/startup_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _ChooseNameBootstrap());
}

class _ChooseNameBootstrap extends StatefulWidget {
  const _ChooseNameBootstrap();

  @override
  State<_ChooseNameBootstrap> createState() => _ChooseNameBootstrapState();
}

class _ChooseNameBootstrapState extends State<_ChooseNameBootstrap> {
  late final Future<_AppDependencies> _dependencies = _loadWithMinimumSplash();

  Future<_AppDependencies> _loadWithMinimumSplash() async {
    final dependencies = _loadDependencies();
    await Future.wait([
      dependencies,
      Future<void>.delayed(const Duration(milliseconds: 1200)),
    ]);
    return dependencies;
  }

  Future<_AppDependencies> _loadDependencies() async {
    final firebaseReady = await FirebaseBootstrap.initialize();
    if (firebaseReady) {
      FirebaseBootstrap.installCrashlyticsHandlers();
    }
    final analyticsService = firebaseReady
        ? AnalyticsService.enabled()
        : AnalyticsService.disabled();
    await analyticsService.logAppOpen();
    final database = LocalNameDatabase();
    final preferences = await SharedPreferences.getInstance();

    return _AppDependencies(
      nameRepository: NameRepository(
        localDatabase: database,
        remoteService: firebaseReady ? FirestoreNameService() : null,
      ),
      userPreferencesRepository: UserPreferencesRepository(
        preferences: preferences,
      ),
      localNameDatabase: database,
      analyticsService: analyticsService,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AppDependencies>(
      future: _dependencies,
      builder: (context, snapshot) {
        final dependencies = snapshot.data;
        if (dependencies == null) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: SplashScreen(),
          );
        }

        return ChooseNameApp(
          nameRepository: dependencies.nameRepository,
          userPreferencesRepository: dependencies.userPreferencesRepository,
          localNameDatabase: dependencies.localNameDatabase,
          analyticsService: dependencies.analyticsService,
        );
      },
    );
  }
}

class _AppDependencies {
  const _AppDependencies({
    required this.nameRepository,
    required this.userPreferencesRepository,
    required this.localNameDatabase,
    required this.analyticsService,
  });

  final NameRepository nameRepository;
  final UserPreferencesRepository userPreferencesRepository;
  final LocalNameDatabase localNameDatabase;
  final AnalyticsService analyticsService;
}
