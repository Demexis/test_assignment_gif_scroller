// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_scroller/GifScrollerWidget/giphy_requestor.dart';

import 'package:gif_scroller/main.dart';

void main() {
  late String prompt;
  late int count;
  late int offset;
  
  setUp(() {
    prompt = "sas";
    count = 1;
    offset = 0;
  });
  
  test("Giphy request returns a gif-image url", () {
    testGiphyRequestReturnsGifUrl(prompt, count, offset);
  });
}

void testGiphyRequestReturnsGifUrl(String prompt, int count, int offset) async {
  bool gifUrlReceived = false;

  var giphyRequestor = GiphyRequestor(apiKey, (p0) {
    gifUrlReceived = true;
  });

  await giphyRequestor.requestMoreGifs(prompt, count, offset);

  expect(gifUrlReceived, true);
}