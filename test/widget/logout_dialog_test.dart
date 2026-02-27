import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Logout dialog shows confirmation message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to log out?'),
          ),
        ),
      ),
    );

    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
  });
}
