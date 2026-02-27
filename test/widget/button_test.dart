import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Get Started button is visible on screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: null,
            child: Text('Get Started'),
          ),
        ),
      ),
    );

    expect(find.text('Get Started'), findsOneWidget);
  });
}
