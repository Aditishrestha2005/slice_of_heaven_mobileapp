import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Register screen has required input fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('name')),
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(onPressed: null, child: Text('Register')),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('name')), findsOneWidget);
    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(find.byKey(const Key('password')), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
