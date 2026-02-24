import 'package:flutter/material.dart';

import '../../yo_ui_base.dart';

class YoDropdownTheme {
  static DropdownMenuThemeData light(BuildContext context) =>
      DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(YoColors.background(context)),
        ),
      );

  static DropdownMenuThemeData dark(BuildContext context) =>
      DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(YoColors.background(context)),
        ),
      );
}
