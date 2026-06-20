import 'package:flutter/foundation.dart';

import 'constants.dart';

class StoreLinks {
  const StoreLinks._();

  static Uri reviewUriFor(TargetPlatform platform) {
    return Uri.parse(switch (platform) {
      TargetPlatform.android => AppConstants.playStoreUrl,
      TargetPlatform.iOS => AppConstants.appStoreUrl,
      _ => AppConstants.appStoreUrl,
    });
  }
}
