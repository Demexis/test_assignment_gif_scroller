import 'package:flutter/material.dart';
import 'package:gif_scroller/Utils/debug_utils.dart';
import 'GifScrollerWidget/gif_scroller_widget.dart';

const String apiKey = 'Wkz9eD0JIKtOPYX8zcI8K88xAATShNz3';
const int gifsPerPagination = 12;

const bool debugMode = false;

void main() {
  DebugUtils.debugMode = debugMode;

  runApp(MaterialApp(
      home: GifScrollerWidget(gifsPerPagination, apiKey, (p0) {})
  ));
}
