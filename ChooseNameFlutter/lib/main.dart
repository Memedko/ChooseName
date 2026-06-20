import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/name_repository.dart';
import 'data/repositories/user_preferences_repository.dart';
import 'data/services/analytics_service.dart';
import 'data/services/firebase_bootstrap.dart';
import 'data/services/firestore_name_service.dart';
import 'data/services/local_name_database.dart';
import 'ui/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(
    ChooseNameApp(
      nameRepository: NameRepository(
        localDatabase: database,
        remoteService: firebaseReady ? FirestoreNameService() : null,
      ),
      userPreferencesRepository: UserPreferencesRepository(
        preferences: preferences,
      ),
      localNameDatabase: database,
      analyticsService: analyticsService,
    ),
  );
}
