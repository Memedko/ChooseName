import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

import '../../domain/models/gender_type.dart';
import '../../domain/models/name_record.dart';

class AnalyticsService {
  const AnalyticsService._({required FirebaseAnalytics? analytics})
    : _analytics = analytics;

  factory AnalyticsService.enabled({FirebaseAnalytics? analytics}) {
    return AnalyticsService._(
      analytics: analytics ?? FirebaseAnalytics.instance,
    );
  }

  factory AnalyticsService.disabled() {
    return const AnalyticsService._(analytics: null);
  }

  final FirebaseAnalytics? _analytics;

  List<NavigatorObserver> get routeObservers {
    final analytics = _analytics;
    if (analytics == null) {
      return const <NavigatorObserver>[];
    }
    return <NavigatorObserver>[FirebaseAnalyticsObserver(analytics: analytics)];
  }

  Future<void> logAppOpen() {
    return _log('app_opened');
  }

  Future<void> logGenderSelected(GenderType gender) {
    return _log('gender_selected', <String, Object>{
      'gender': gender.storageValue,
    });
  }

  Future<void> logNameLiked(NameRecord name, GenderType gender) {
    return _logNameDecision('name_liked', name, gender);
  }

  Future<void> logNameDisliked(NameRecord name, GenderType gender) {
    return _logNameDecision('name_disliked', name, gender);
  }

  Future<void> logSearch(GenderType gender, String query) {
    if (query.isEmpty) {
      return Future<void>.value();
    }
    return _log('name_search', <String, Object>{
      'gender': gender.storageValue,
      'query_length': query.length,
    });
  }

  Future<void> logResetDisliked(GenderType gender) {
    return _log('reset_disliked_names', <String, Object>{
      'gender': gender.storageValue,
    });
  }

  Future<void> _logNameDecision(
    String name,
    NameRecord record,
    GenderType gender,
  ) {
    return _log(name, <String, Object>{
      'gender': gender.storageValue,
      if (record.nameId != null) 'name_id': record.nameId!,
    });
  }

  Future<void> _log([String name = '', Map<String, Object>? parameters]) {
    final analytics = _analytics;
    if (analytics == null) {
      return Future<void>.value();
    }
    return analytics.logEvent(name: name, parameters: parameters);
  }
}
