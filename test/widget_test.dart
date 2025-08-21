import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrop_timer/main.dart';

void main() {
  testWidgets('Hackathon Timer shows opening countdown', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // The first screen is LoginScreen, so we need to simulate login
    // Enter username
    await tester.enterText(find.byType(TextField).first, 'user');
    // Enter password
    await tester.enterText(find.byType(TextField).last, '1234');

    // Tap login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait for navigation

    // Now we should be at StartScreen
    expect(find.text('Start Hackathon Timer'), findsOneWidget);

    // Tap Start button to go to TimerScreen
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // On TimerScreen, countdown starts at 10
    expect(find.text('10'), findsOneWidget);

    // Advance 1 second
    await tester.pump(const Duration(seconds: 1));

    // Countdown should now show 9
    expect(find.text('9'), findsOneWidget);
  });
}
