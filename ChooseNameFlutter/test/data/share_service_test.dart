import 'package:choose_name/data/services/share_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('choose_name/share_test');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('invokes native share method with text and subject', () async {
    MethodCall? capturedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          capturedCall = call;
          return true;
        });

    final service = ShareService(channel: channel);
    final result = await service.shareText('Hello', subject: 'Subject');

    expect(result, ShareResult.shared);
    expect(capturedCall?.method, 'shareText');
    expect(capturedCall?.arguments, <String, Object?>{
      'text': 'Hello',
      'subject': 'Subject',
    });
  });
}
