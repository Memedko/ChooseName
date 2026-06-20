import 'package:choose_name/ui/core/constants.dart';
import 'package:choose_name/ui/core/store_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses Play Store URL on Android', () {
    expect(
      StoreLinks.reviewUriFor(TargetPlatform.android).toString(),
      AppConstants.playStoreUrl,
    );
  });

  test('uses App Store URL on iOS', () {
    expect(
      StoreLinks.reviewUriFor(TargetPlatform.iOS).toString(),
      AppConstants.appStoreUrl,
    );
  });
}
