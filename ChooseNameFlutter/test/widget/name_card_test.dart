import 'package:choose_name/domain/models/name_decision.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/ui/features/names/views/name_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows generated full name and liked status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NameCard(
            name: const NameRecord(name: 'Марко', decision: NameDecision.liked),
            fullName: 'Марко Іванович Коваленко',
            detailsLabel: 'Деталі',
            likedStatusLabel: 'Ви вподобали це імʼя',
            dislikedStatusLabel: 'Ви не вподобали це імʼя',
            onDetails: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('card_full_name')), findsOneWidget);
    expect(find.text('Марко Іванович Коваленко'), findsOneWidget);
    expect(find.byKey(const ValueKey('card_decision_status')), findsOneWidget);
    expect(find.text('Ви вподобали це імʼя'), findsOneWidget);
  });
}
