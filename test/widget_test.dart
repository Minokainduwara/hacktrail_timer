import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrop_timer/main.dart';

void main() {
  testWidgets('Hackathon Timer shows opening countdown',
      (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const HackathonTimerApp());

    // At the very beginning, it should show "10"
    expect(find.text('10'), findsOneWidget);

    // Advance by 1 second
    await tester.pump(const Duration(seconds: 1));

    // Now the countdown should show "9"
    expect(find.text('9'), findsOneWidget);
  });
}
