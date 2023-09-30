import 'package:flutter/material.dart';

class SplitModeHelper {
  static bool hideSplit = false;

  static bool getMode(BuildContext context) {
    bool splitMode;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    splitMode = false;
    if (screenWidth > 700 && screenHeight > 700) {
      splitMode = true;
    }
    return splitMode;
  }
}

//https://pub.dartlang.org/packages/mmkv_flutter#-readme-tab- 官方說明
