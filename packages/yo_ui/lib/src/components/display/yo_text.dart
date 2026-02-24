import 'package:flutter/material.dart';

import '../../../yo_ui_base.dart';

class YoText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const YoText(
    this.text, {
    super.key,
    this.style,
    this.align,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.color,
    this.fontWeight,
    this.fontSize,
  });

  // Simple static methods sebagai alternative ke constructor
  static Widget displayLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.displayLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget displayMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.displayMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget displaySmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.displaySmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget headlineLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.headlineLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget headlineMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.headlineMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget headlineSmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.headlineSmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget titleLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.titleLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget titleMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.titleMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget titleSmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.titleSmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  // ... Buat untuk semua variant lainnya

  static Widget bodyLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.bodyLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget bodyMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.bodyMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget bodySmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.bodySmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget labelSmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.labelSmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget labelMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.labelMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget labelLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.labelLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget monoLarge(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.monoLarge,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget monoMedium(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.monoMedium,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static Widget monoSmall(
    String text, {
    Key? key,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap = true,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return _YoTextWithBuilder(
      text: text,
      styleBuilder: YoTextTheme.monoSmall,
      key: key,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

class _YoTextWithBuilder extends StatelessWidget {
  final String text;
  final TextStyle Function(BuildContext) styleBuilder;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const _YoTextWithBuilder({
    required this.text,
    required this.styleBuilder,
    this.align,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.color,
    this.fontWeight,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle finalStyle = styleBuilder(context);

    return Text(
      text,
      style: finalStyle.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
