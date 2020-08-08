import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:flutter/material.dart';

class ScreenSizeService {
  static int _screenFull = 1850;
  static int _screenHigh = 1400;
  static int _screenMedium = 915;

  static ScreenSize getSize(BuildContext context) {
    if (MediaQuery.of(context).size.width >= _screenFull) {
      return ScreenSize.FULL;
    } else if (MediaQuery.of(context).size.width >= _screenHigh) {
      return ScreenSize.HIGH;
    } else if (MediaQuery.of(context).size.width >= _screenMedium) {
      return ScreenSize.MEDIUM;
    } else {
      return ScreenSize.SMALL;
    }
  }

  static bool compareSize(BuildContext context, ScreenSize screenSize) {
    return getSize(context) == screenSize;
  }
}
