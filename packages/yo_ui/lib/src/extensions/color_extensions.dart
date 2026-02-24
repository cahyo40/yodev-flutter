import 'package:flutter/material.dart';

import '../../yo_ui.dart';

extension YoColorContext on BuildContext {
  Color get accentColor => _active.accent;

  Gradient get accentGradient => YoColors.accentGradient(this);
  Color get backgroundColor => _active.background;
  Color get cardBorderColor => _active.cardBorderColor;
  Color get cardColor => _active.cardColor;
  Color get colorTextBtn => Theme.of(this).brightness == Brightness.dark
      ? textColor // dari yo_ui
      : backgroundColor; // dari yo_ui
  Color get errorColor => YoColors.error(this);
  Color get gray100 => YoColors.gray100(this);
  Color get gray200 => YoColors.gray200(this);
  Color get gray300 => YoColors.gray300(this);
  Color get gray400 => YoColors.gray400(this);
  // grey scale
  Color get gray50 => YoColors.gray50(this);
  Color get gray500 => YoColors.gray500(this);
  Color get gray600 => YoColors.gray600(this);
  Color get gray700 => YoColors.gray700(this);

  Color get gray800 => YoColors.gray800(this);
  Color get gray900 => YoColors.gray900(this);
  Color get infoColor => YoColors.info(this);
  Color get onBackgroundColor => _active.onBackground;
  Color get onCardColor => _active.onCard;
  Color get onPrimaryColor => _active.onPrimary;
  /* --------------------------------------------------------------- */
  /*  2.  SAME SHORT-HAND GETTERS AS BEFORE                          */
  /* --------------------------------------------------------------- */
  Color get primaryColor => _active.primary;
  // gradients
  Gradient get primaryGradient => YoColors.primaryGradient(this);
  Color get secondaryColor => _active.secondary;
  // Color get onPrimaryBW => _active.onPrimaryBW;
  // Color get onBackgroundBW => _active.onBackgroundBW;

  // semantic
  Color get successColor => YoColors.success(this);

  Color get textColor => _active.text;
  Color get warningColor => YoColors.warning(this);

  /* --------------------------------------------------------------- */
  /*  1.  READ THE SCHEME STORED IN THEME EXTENSION                  */
  /* --------------------------------------------------------------- */
  YoCorePalette get _active {
    final bright = Theme.of(this).brightness;
    final scheme = Theme.of(this).extension<YoScheme>()?.scheme ??
        YoColorScheme.defaultScheme; // fallback
    return kYoPalettes[scheme]![bright]!;
  }
}
