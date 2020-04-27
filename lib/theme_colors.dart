import "package:flutter/material.dart";

class ThemeColors {
  ThemeColors._(); // this basically makes it so you can instantiate this class
  static const MaterialColor primary_color = MaterialColor(0xFF632ade, _theme_primary_color);

  static const Map<int, Color> _theme_primary_color = {
    50: Color.fromRGBO(255, 27, 161, .1),
    100: Color.fromRGBO(255, 27, 161, .2),
    200: Color.fromRGBO(255, 27, 161, .3),
    300: Color.fromRGBO(255, 27, 161, .4),
    400: Color.fromRGBO(255, 27, 161, .5),
    500: Color.fromRGBO(255, 27, 161, .6),
    600: Color.fromRGBO(255, 27, 161, .7),
    700: Color.fromRGBO(255, 27, 161, .8),
    800: Color.fromRGBO(255, 27, 161, .9),
    900: Color.fromRGBO(255, 27, 161, 1),
  };
}