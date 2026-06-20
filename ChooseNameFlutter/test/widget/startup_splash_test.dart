import 'package:choose_name/ui/features/splash/views/startup_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Ukrainian splash artwork', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SizedBox.expand(child: SplashScreen())),
    );

    expect(find.text('Ім’я малюка'), findsOneWidget);
    expect(find.text('Оберіть ім’я для вашої дитини'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });
}
