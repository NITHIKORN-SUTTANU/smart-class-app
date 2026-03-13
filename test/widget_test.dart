import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_class_app/screens/home_screen.dart';

void main() {
  testWidgets('Home screen shows welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );
    await tester.pump();

    expect(find.text('Welcome to Smart Class'), findsOneWidget);
    expect(find.text('Smart Class App'), findsOneWidget);
  });

  testWidgets('Home screen has Check-in and Finish Class buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );
    await tester.pump();

    expect(find.text('Check-in'), findsOneWidget);
    expect(find.text('Finish Class'), findsOneWidget);
  });
}
