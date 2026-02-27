import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen has email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(onPressed: null, child: Text('Login')),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(find.byKey(const Key('password')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}