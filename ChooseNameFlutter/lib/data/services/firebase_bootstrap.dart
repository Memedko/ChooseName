import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<bool> initialize() async {
    try {
      await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('Firebase disabled until platform config is added: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  static void installCrashlyticsHandlers() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return;
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      return true;
    };
  }
}
