import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_scroller/GifScrollerWidget/gif_scroller.dart';
import 'package:gif_scroller/Utils/debug_utils.dart';

class GifScrollerWidget extends StatefulWidget {
  // required fields
  final int gifsPerPagination;
  final String apiKey;

  // events
  final Function(String) onPromptEntered;

  const GifScrollerWidget(
      this.gifsPerPagination, this.apiKey, this.onPromptEntered, {super.key});

  @override
  State<GifScrollerWidget> createState() => _GifScrollerWidgetState();
}

class _GifScrollerWidgetState extends State<GifScrollerWidget> {
  var headerTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: Colors.white,
    fontFamily: 'Grinched',
  );

  final SearchController searchEditingController = SearchController();
  final ScrollController scrollController = ScrollController();

  late GifScroller gifScroller;
  late Timer updateTimer;

  @override
  void initState() {
    super.initState();

    gifScroller = GifScroller(widget.apiKey, promptEntered, gifsChanged);

    DebugUtils.printDebug("Setting up the listener.");
    // Setup the listener.
    scrollController.addListener(() {
      // source: https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          DebugUtils.printDebug("Scroller at the top.");
        } else {
          DebugUtils.printDebug("Scroller at the bottom.");
          gifScroller.requestMoreGifs(widget.gifsPerPagination);
        }
      }

      // request gifs when scrolled more than 50% of the content
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent / 2) {
        gifScroller.requestMoreGifs(widget.gifsPerPagination);
      }
    });

    startUpdateTimer();
  }

  @override
  void dispose() {
    super.dispose();
    updateTimer.cancel();
  }

  void submitPrompt(String prompt){
    gifScroller.submitPrompt(prompt, widget.gifsPerPagination);
  }

  void promptEntered(String promptEntered){
    searchEditingController.value = TextEditingValue.empty;
    widget.onPromptEntered(promptEntered);
  }

  void gifsChanged(){
    setState(() {});
  }

  void startUpdateTimer() {
    updateTimer = Timer.periodic(
      const Duration(seconds: 1), (Timer timer) {
        DebugUtils.printDebug("Update tick...");
        checkScrollable();
      },
    );
  }

  void checkScrollable() {
    // skip if prompt wasn't entered
    if(gifScroller.prompt == null) {
      return;
    }

    bool scrollable = scrollController.position.maxScrollExtent != 0;

    // request gifs if there is not enouqh elements for scroller to show
    if (!scrollable) {
      gifScroller.requestMoreGifs(widget.gifsPerPagination);
    }
  }

  List<Widget> extractGifImagesForAGrid(int index){
    List<Widget> images = [];

    for(int i = 0; i < widget.gifsPerPagination; i++){
      var imageIndex = index * widget.gifsPerPagination + i;
      DebugUtils.printDebug("Image index: $imageIndex");

      if(gifScroller.listOfGifUrls.length <= imageIndex){
        continue;
      }

      images.add(
        Image(
            image: NetworkImage(gifScroller.listOfGifUrls[imageIndex])
        )
      );
    }

    return images;
  }

  List<Widget> extractGrids() {
    List<Widget> grids = [];

    for (int i = 0; i < gifScroller.listOfGifUrls.length / widget.gifsPerPagination; i++) {
      var localIndex = i;
      grids.add(
        // struggled with the layout errors for a long time until I found this post:
        // https://stackoverflow.com/questions/51765814/flutter-gridview-inside-listview
        GridView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
          shrinkWrap: true, // You won't see infinite size error
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3
          ),
          children: extractGifImagesForAGrid(localIndex),
        ),
      );
    }

    return grids;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.grey[900],
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'GIF-scroller',
            style: headerTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.red[400],
        ),
        body: Center(
          child: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child:
                      SearchBar(
                        controller: searchEditingController,
                        onSubmitted: submitPrompt,
                        hintText: "Enter your prompt...",
                      ),
                    ),
                    TextButton(
                      key: const Key("submitButton"),
                      onPressed: () =>
                          submitPrompt(searchEditingController.value.text),
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
                Expanded(child:
                  ListView(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    children: extractGrids(),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}