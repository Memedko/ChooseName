import 'package:choose_name/data/services/analytics_service.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('disabled analytics service is safe to call without Firebase', () async {
    final analytics = AnalyticsService.disabled();

    await analytics.logAppOpen();
    await analytics.logGenderSelected(GenderType.male);
    await analytics.logNameLiked(
      const NameRecord(nameId: 'marko', name: 'Марко'),
      GenderType.male,
    );
    await analytics.logNameDisliked(
      const NameRecord(nameId: 'ivan', name: 'Іван'),
      GenderType.male,
    );
    await analytics.logSearch(GenderType.female, 'Лея');
    await analytics.logResetDisliked(GenderType.female);

    expect(analytics.routeObservers, isEmpty);
  });
}
