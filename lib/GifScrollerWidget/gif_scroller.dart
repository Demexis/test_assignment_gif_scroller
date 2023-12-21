import 'package:flutter/widgets.dart';
import 'package:gif_scroller/GifScrollerWidget/giphy_requestor.dart';

import '../Utils/debug_utils.dart';

class GifScroller {
  // events
  final Function(String) onPromptEntered;
  final VoidCallback onGifsChanged;

  late GiphyRequestor giphyRequestor;

  String? prompt;
  List<String> listOfGifUrls = [];
  int gifsOffset = 0;

  final String apiKey;

  bool isLoading = false;

  GifScroller(this.apiKey, this.onPromptEntered, this.onGifsChanged) {
    giphyRequestor = GiphyRequestor(apiKey, receiveGifUrl);
  }

  void receiveGifUrl(String url){
    listOfGifUrls.add(url);
    onGifsChanged();
  }

  void submitPrompt(String prompt, int initGifsCount) {
    isLoading = false;
    this.prompt = prompt;

    DebugUtils.printDebug("Submitting new prompt: $prompt");

    listOfGifUrls.clear();
    requestMoreGifs(initGifsCount);
    onPromptEntered(prompt);
  }

  void requestMoreGifs(int count) async {
    // skip if prompt wasn't entered
    if (prompt == null) {
      return;
    }

    if (isLoading) {
      DebugUtils.printDebug("Is already loading gifs");
      return;
    }

    if (prompt!.trim().isEmpty) {
      DebugUtils.printDebug("Prompt is empty and can't be used to request gifs.");
      return;
    }

    isLoading = true;

    await giphyRequestor.requestMoreGifs(prompt!, count, gifsOffset);
    gifsOffset += count;

    isLoading = false;
  }
}