class DebugUtils {
  // I believe there may exist some directives, like '#if EDITOR_ONLY', but i'm
  // just using this in order to not print debug-messages in the build.
  static bool debugMode = false;

  static void printDebug(Object? printObject){
    if(!debugMode){
      return;
    }

    print(printObject);
  }
}