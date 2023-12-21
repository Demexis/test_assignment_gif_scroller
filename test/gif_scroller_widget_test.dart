// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_scroller/GifScrollerWidget/gif_scroller_widget.dart';

import 'package:gif_scroller/main.dart';

void main() {
  testWidgets('Enter a prompt', (WidgetTester tester) async {
    bool promptEntered = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(GifScrollerWidget(gifsPerPagination, apiKey, (p0) {
      promptEntered = true;
    },));

    expect(find.byKey(const Key("submitButton")), findsOneWidget);

    await tester.tap(find.byKey(const Key("submitButton")));

    expect(promptEntered, true);
  });
}
