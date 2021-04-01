import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/main.dart';

void main() {
  testWidgets(
    'The app is initialized with the correct basic setup.',
    (WidgetTester tester) async {
      // Build and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Verify that the search bar is initialized.
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Verify that the list view has been initialized.
      expect(find.text('Start a new search...'), findsOneWidget);
    },
  );
}