import 'dart:convert';

import 'package:http/http.dart';

import '../Utils/debug_utils.dart';

class GiphyRequestor {
  final String apiKey;

  Function(String) onGifUrlReceived;

  GiphyRequestor(this.apiKey, this.onGifUrlReceived);

  requestMoreGifs(String prompt, int count, int offset) async {
    if (prompt.trim().isEmpty) {
      DebugUtils.printDebug("Prompt is empty and can't be used to request gifs.");
      return;
    }

    DebugUtils.printDebug("Requesting gifs");

    var requestUrl = Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=$apiKey&limit=$count&offset=$offset&q=$prompt');

    DebugUtils.printDebug("Input URL: $requestUrl");

    Response response = await get(requestUrl);
    Map data = jsonDecode(response.body);

    DebugUtils.printDebug("Decoded response data: $data");

    data['data'].forEach((dataRow) {
      (dataRow as Map<String, dynamic>).forEach((key, value) {
        if (key == 'images') {
          onGifUrlReceived(value['downsized']['url']);
        }
      });
    });
  }
}