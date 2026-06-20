import 'package:flutter/services.dart';

enum ShareResult { shared, copied }

class ShareService {
  const ShareService({
    MethodChannel channel = const MethodChannel('choose_name/share'),
  }) : _channel = channel;

  final MethodChannel _channel;

  Future<ShareResult> shareText(String text, {String? subject}) async {
    try {
      final shared = await _channel.invokeMethod<bool>('shareText', {
        'text': text,
        'subject': subject,
      });
      if (shared ?? false) {
        return ShareResult.shared;
      }
    } on MissingPluginException {
      // Fall through to clipboard for tests, desktop, and unimplemented hosts.
    } on PlatformException {
      // The Android chooser may be unavailable on unusual devices.
    }

    await Clipboard.setData(ClipboardData(text: text));
    return ShareResult.copied;
  }
}
