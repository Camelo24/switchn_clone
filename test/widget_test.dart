import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchn/screens/welcome_screen.dart'; // Fixed import

void main() {
  testWidgets('Welcome screen has title and continue button', (WidgetTester tester) async {

    // Pump the WelcomeScreen directly, bypassing Firebase and AuthGate
    await tester.pumpWidget(const MaterialApp(
      home: WelcomeScreen(),
    ));

    // Look for the exact text on the screen
    expect(find.text('Welcome to Switchn'), findsOneWidget);
    expect(find.text('Stress free airtime transfer'), findsOneWidget);
    expect(find.text('AGREE AND CONTINUE'), findsOneWidget);
  });
}