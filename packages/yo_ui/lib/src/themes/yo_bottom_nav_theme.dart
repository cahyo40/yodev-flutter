import 'package:flutter/material.dart';

import '../colors/yo_colors.dart';

class YoBottomNavTheme {
  static BottomNavigationBarThemeData  light(BuildContext context) => BottomNavigationBarThemeData(
    backgroundColor: YoColors.background(context),
    selectedItemColor: YoColors.primary(context),
    unselectedItemColor: YoColors.lightGray500,
    elevation: 8,
  );

  static BottomNavigationBarThemeData  dark(BuildContext context) => BottomNavigationBarThemeData(
    backgroundColor: YoColors.background(context),
    selectedItemColor: YoColors.primary(context),
    unselectedItemColor: YoColors.darkGray500,
    elevation: 8,
  );
}
