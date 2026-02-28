// File: yo_color_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yo_ui/yo_ui.dart';

/// Color data with metadata
class YoColorData {
  final Color color;
  final String name;
  final YoColorPalette palette;

  const YoColorData({
    required this.color,
    required this.name,
    required this.palette,
  });
}

/// Predefined color palettes
enum YoColorPalette {
  material('Material', Icons.palette),
  pastel('Pastel', Icons.gradient),
  grayscale('Grayscale', Icons.contrast),
  custom('Custom', Icons.colorize);

  final String label;
  final IconData icon;

  const YoColorPalette(this.label, this.icon);
}

/// Color picker widget
class YoColorPicker extends StatefulWidget {
  /// Currently selected color
  final Color? selectedColor;

  /// Callback when a color is selected
  final ValueChanged<Color> onColorSelected;

  /// Initially selected palette
  final YoColorPalette initialPalette;

  /// Whether to show the hex input
  final bool showHexInput;

  /// Whether to show RGB sliders
  final bool showRgbSliders;

  /// Whether to show opacity slider
  final bool showOpacity;

  /// Whether to show palette tabs
  final bool showPalettes;

  /// Whether to show color preview
  final bool showPreview;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Label text
  final String? labelText;

  /// Height of the picker
  final double height;

  /// Background color
  final Color? backgroundColor;

  const YoColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.initialPalette = YoColorPalette.material,
    this.showHexInput = true,
    this.showRgbSliders = true,
    this.showOpacity = false,
    this.showPalettes = true,
    this.showPreview = true,
    this.crossAxisCount = 6,
    this.labelText,
    this.height = 400,
    this.backgroundColor,
  });

  @override
  State<YoColorPicker> createState() => _YoColorPickerState();

  /// Show color picker as a bottom sheet
  static Future<Color?> showAsBottomSheet({
    required BuildContext context,
    Color? selectedColor,
    YoColorPalette initialPalette = YoColorPalette.material,
    String title = 'Select Color',
    bool showOpacity = false,
  }) {
    return showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _YoColorPickerBottomSheet(
        selectedColor: selectedColor,
        initialPalette: initialPalette,
        title: title,
        showOpacity: showOpacity,
      ),
    );
  }

  /// Show color picker as a dialog
  static Future<Color?> showAsDialog({
    required BuildContext context,
    Color? selectedColor,
    YoColorPalette initialPalette = YoColorPalette.material,
    String title = 'Select Color',
    bool showOpacity = false,
  }) {
    return showDialog<Color>(
      context: context,
      builder: (context) => _YoColorPickerDialog(
        selectedColor: selectedColor,
        initialPalette: initialPalette,
        title: title,
        showOpacity: showOpacity,
      ),
    );
  }
}

/// Color picker button that shows picker on tap
class YoColorPickerButton extends StatelessWidget {
  /// Currently selected color
  final Color? selectedColor;

  /// Callback when a color is selected
  final ValueChanged<Color> onColorSelected;

  /// Label text
  final String? labelText;

  /// Hint text when no color is selected
  final String hintText;

  /// Border radius
  final double borderRadius;

  /// Border color
  final Color? borderColor;

  /// Background color
  final Color? backgroundColor;

  /// Whether to show as bottom sheet or dialog
  final bool showAsBottomSheet;

  /// Title for the picker
  final String pickerTitle;

  /// Initial palette
  final YoColorPalette initialPalette;

  /// Whether to show opacity slider
  final bool showOpacity;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Whether the button is enabled
  final bool enabled;

  const YoColorPickerButton({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.labelText,
    this.hintText = 'Select a color',
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.showAsBottomSheet = true,
    this.pickerTitle = 'Select Color',
    this.initialPalette = YoColorPalette.material,
    this.showOpacity = false,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _showPicker(context) : null,
      child: Container(
        padding: padding ?? EdgeInsets.all(context.yoSpacingMd),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? context.gray300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selectedColor ?? context.gray200,
                borderRadius: BorderRadius.circular(context.yoRadiusMd),
                border: Border.all(color: context.gray300),
                boxShadow: selectedColor != null
                    ? [
                        BoxShadow(
                          color: selectedColor!.withAlpha(60),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: selectedColor == null
                  ? Icon(
                      Icons.colorize,
                      color: context.gray400,
                      size: 20,
                    )
                  : null,
            ),
            const YoSpace.width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null) ...[
                    YoText(
                      labelText!,
                      style: context.yoLabelSmall.copyWith(
                        color: context.gray500,
                      ),
                    ),
                    const YoSpace.height(2),
                  ],
                  YoText(
                    selectedColor != null
                        ? '#${selectedColor!.toHex().substring(1).toUpperCase()}'
                        : hintText,
                    style: context.yoBodyMedium.copyWith(
                      color: selectedColor != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedColor != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: context.gray500),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    Color? result;

    if (showAsBottomSheet) {
      result = await YoColorPicker.showAsBottomSheet(
        context: context,
        selectedColor: selectedColor,
        initialPalette: initialPalette,
        title: pickerTitle,
        showOpacity: showOpacity,
      );
    } else {
      result = await YoColorPicker.showAsDialog(
        context: context,
        selectedColor: selectedColor,
        initialPalette: initialPalette,
        title: pickerTitle,
        showOpacity: showOpacity,
      );
    }

    if (result != null) {
      onColorSelected(result);
    }
  }
}

/// Predefined colors organized by palette
class YoColorPresets {
  /// All predefined colors
  static const List<YoColorData> all = [
    // Material Design Colors - Primary
    YoColorData(
        color: Color(0xFFF44336),
        name: 'Red',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFE91E63),
        name: 'Pink',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF9C27B0),
        name: 'Purple',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF673AB7),
        name: 'Deep Purple',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF3F51B5),
        name: 'Indigo',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF2196F3),
        name: 'Blue',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF03A9F4),
        name: 'Light Blue',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF00BCD4),
        name: 'Cyan',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF009688),
        name: 'Teal',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF4CAF50),
        name: 'Green',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF8BC34A),
        name: 'Light Green',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFCDDC39),
        name: 'Lime',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFFFEB3B),
        name: 'Yellow',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFFFC107),
        name: 'Amber',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFFF9800),
        name: 'Orange',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFFFF5722),
        name: 'Deep Orange',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF795548),
        name: 'Brown',
        palette: YoColorPalette.material),
    YoColorData(
        color: Color(0xFF607D8B),
        name: 'Blue Grey',
        palette: YoColorPalette.material),

    // Pastel Colors
    YoColorData(
        color: Color(0xFFFFB3BA),
        name: 'Pastel Pink',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFFFDFBA),
        name: 'Pastel Peach',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFFFFFBA),
        name: 'Pastel Yellow',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFBAFFC9),
        name: 'Pastel Mint',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFBAE1FF),
        name: 'Pastel Blue',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFE0BBE4),
        name: 'Pastel Lavender',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFFEC8D8),
        name: 'Pastel Rose',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFD4F0F0),
        name: 'Pastel Cyan',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFCCE2CB),
        name: 'Pastel Sage',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFF6EAC2),
        name: 'Pastel Cream',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFDCD0FF),
        name: 'Pastel Violet',
        palette: YoColorPalette.pastel),
    YoColorData(
        color: Color(0xFFFFF0F5),
        name: 'Lavender Blush',
        palette: YoColorPalette.pastel),

    // Grayscale
    YoColorData(
        color: Color(0xFF000000),
        name: 'Black',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFF212121),
        name: 'Gray 900',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFF424242),
        name: 'Gray 800',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFF616161),
        name: 'Gray 700',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFF757575),
        name: 'Gray 600',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFF9E9E9E),
        name: 'Gray 500',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFBDBDBD),
        name: 'Gray 400',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFE0E0E0),
        name: 'Gray 300',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFEEEEEE),
        name: 'Gray 200',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFF5F5F5),
        name: 'Gray 100',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFFAFAFA),
        name: 'Gray 50',
        palette: YoColorPalette.grayscale),
    YoColorData(
        color: Color(0xFFFFFFFF),
        name: 'White',
        palette: YoColorPalette.grayscale),
  ];

  YoColorPresets._();

  /// Get colors by palette
  static List<YoColorData> byPalette(YoColorPalette palette) {
    if (palette == YoColorPalette.custom) return [];
    return all.where((color) => color.palette == palette).toList();
  }

  /// Search colors by name
  static List<YoColorData> search(String query) {
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    return all
        .where((color) => color.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

/// Bottom sheet variant
class _YoColorPickerBottomSheet extends StatefulWidget {
  final Color? selectedColor;
  final YoColorPalette initialPalette;
  final String title;
  final bool showOpacity;

  const _YoColorPickerBottomSheet({
    this.selectedColor,
    required this.initialPalette,
    required this.title,
    required this.showOpacity,
  });

  @override
  State<_YoColorPickerBottomSheet> createState() =>
      _YoColorPickerBottomSheetState();
}

class _YoColorPickerBottomSheetState extends State<_YoColorPickerBottomSheet> {
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YoText(
                  widget.title,
                  style: context.yoTitleMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    if (_selectedColor != null)
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_selectedColor),
                        child: YoText.bodyMedium('Select'),
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Picker
          Expanded(
            child: YoColorPicker(
              selectedColor: _selectedColor,
              initialPalette: widget.initialPalette,
              showOpacity: widget.showOpacity,
              onColorSelected: (color) {
                setState(() => _selectedColor = color);
              },
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }
}

/// Dialog variant
class _YoColorPickerDialog extends StatefulWidget {
  final Color? selectedColor;
  final YoColorPalette initialPalette;
  final String title;
  final bool showOpacity;

  const _YoColorPickerDialog({
    this.selectedColor,
    required this.initialPalette,
    required this.title,
    required this.showOpacity,
  });

  @override
  State<_YoColorPickerDialog> createState() => _YoColorPickerDialogState();
}

class _YoColorPickerDialogState extends State<_YoColorPickerDialog> {
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YoText(
                  widget.title,
                  style: context.yoTitleMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const YoSpace.height(8),
            // Picker
            Expanded(
              child: YoColorPicker(
                selectedColor: _selectedColor,
                initialPalette: widget.initialPalette,
                showOpacity: widget.showOpacity,
                onColorSelected: (color) {
                  setState(() => _selectedColor = color);
                },
                height: double.infinity,
                crossAxisCount: 5,
              ),
            ),
            const YoSpace.height(16),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: YoText.bodyMedium('Cancel'),
                ),
                const YoSpace.width(8),
                ElevatedButton(
                  onPressed: _selectedColor != null
                      ? () => Navigator.of(context).pop(_selectedColor)
                      : null,
                  child: YoText.bodyMedium('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }
}

class _YoColorPickerState extends State<YoColorPicker> {
  late YoColorPalette _selectedPalette;
  late Color _currentColor;
  late TextEditingController _hexController;
  late double _hue;
  late double _saturation;
  late double _value;
  late double _opacity;
  List<YoColorData> _filteredColors = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.backgroundColor,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
        border: Border.all(color: context.gray200),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: YoText(
                  widget.labelText!,
                  style: context.yoLabelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.gray600,
                  ),
                ),
              ),

            // Preview and Hex Input
            if (widget.showPreview || widget.showHexInput)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (widget.showPreview) ...[
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius: BorderRadius.circular(context.yoRadiusLg),
                          border: Border.all(color: context.gray300),
                          boxShadow: [
                            BoxShadow(
                              color: _currentColor.withAlpha(80),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const YoSpace.width(12),
                    ],
                    if (widget.showHexInput)
                      Expanded(
                        child: YoTextFormField(
                          controller: _hexController,
                          labelText: 'Hex Color',
                          hintText: 'FFFFFF',
                          inputStyle: YoInputStyle.filled,
                          borderRadius: 8.0,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: YoText(
                              '#',
                              style: TextStyle(
                                fontSize: 16,
                                color: context.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-fA-F]')),
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onChanged: (value) {
                            final color = _hexToColor(value);
                            if (color != null) {
                              _updateHSVFromColor(color);
                              _setColor(color);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),

            // Hue Slider
            if (widget.showRgbSliders) ...[
              _buildColorSlider(
                label: 'Hue',
                value: _hue,
                max: 360,
                gradient: LinearGradient(
                  colors: List.generate(
                    7,
                    (i) => HSVColor.fromAHSV(1, i * 60, 1, 1).toColor(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _hue = value;
                    _updateColorFromHSV();
                  });
                },
              ),
              _buildColorSlider(
                label: 'Saturation',
                value: _saturation * 100,
                max: 100,
                gradient: LinearGradient(
                  colors: [
                    HSVColor.fromAHSV(1, _hue, 0, _value).toColor(),
                    HSVColor.fromAHSV(1, _hue, 1, _value).toColor(),
                  ],
                ),
                onChanged: (value) {
                  setState(() {
                    _saturation = value / 100;
                    _updateColorFromHSV();
                  });
                },
              ),
              _buildColorSlider(
                label: 'Brightness',
                value: _value * 100,
                max: 100,
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    HSVColor.fromAHSV(1, _hue, _saturation, 1).toColor(),
                  ],
                ),
                onChanged: (value) {
                  setState(() {
                    _value = value / 100;
                    _updateColorFromHSV();
                  });
                },
              ),
            ],

            // Opacity Slider
            if (widget.showOpacity)
              _buildColorSlider(
                label: 'Opacity',
                value: _opacity * 100,
                max: 100,
                gradient: LinearGradient(
                  colors: [
                    _currentColor.withAlpha(0),
                    _currentColor.withAlpha(255),
                  ],
                ),
                onChanged: (value) {
                  setState(() {
                    _opacity = value / 100;
                    _setColor(
                        _currentColor.withAlpha((_opacity * 255).round()));
                  });
                },
              ),

            // Palette Tabs
            if (widget.showPalettes &&
                _selectedPalette != YoColorPalette.custom)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: YoText(
                      'Color Palettes',
                      style:
                          context.yoLabelSmall.copyWith(color: context.gray500),
                    ),
                  ),
                  YoBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: YoColorPalette.values.length - 1,
                      itemBuilder: (context, index) {
                        final palette = YoColorPalette.values[index];
                        final isSelected = _selectedPalette == palette;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: YoText.bodyMedium(palette.label),
                            avatar: Icon(palette.icon, size: 16),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedPalette = palette;
                                  _updateFilteredColors();
                                });
                              }
                            },
                            selectedColor: context.primaryColor.withAlpha(40),
                            checkmarkColor: context.primaryColor,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? context.primaryColor
                                  : context.textColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const YoSpace.height(8),
                ],
              ),

            // Color Grid
            if (widget.showPalettes && _filteredColors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredColors.length,
                  itemBuilder: (context, index) {
                    final colorData = _filteredColors[index];
                    final isSelected =
                        _currentColor.toARGB32() == colorData.color.toARGB32();
                    return Tooltip(
                      message: colorData.name,
                      child: InkWell(
                        onTap: () {
                          _updateHSVFromColor(colorData.color);
                          _setColor(colorData.color);
                        },
                        borderRadius: BorderRadius.circular(context.yoRadiusMd),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorData.color,
                            borderRadius: BorderRadius.circular(context.yoRadiusMd),
                            border: Border.all(
                              color: isSelected
                                  ? context.textColor
                                  : context.gray200,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorData.color.withAlpha(100),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: colorData.color.contrastColor,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedPalette = widget.initialPalette;
    _currentColor = widget.selectedColor ?? const Color(0xFF2196F3);
    _hexController = TextEditingController(text: _colorToHex(_currentColor));
    _updateHSVFromColor(_currentColor);
    _opacity = (_currentColor.a * 255).round() / 255;
    _updateFilteredColors();
  }

  Widget _buildColorSlider({
    required String label,
    required double value,
    required double max,
    required Gradient gradient,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              YoText(
                label,
                style: context.yoLabelSmall.copyWith(color: context.gray500),
              ),
              YoText(
                value.round().toString(),
                style: context.yoLabelSmall.copyWith(
                  color: context.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const YoSpace.height(4),
          Container(
            height: 24,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(context.yoRadiusLg),
              border: Border.all(color: context.gray200),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 24,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10,
                  elevation: 2,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                trackShape: const RoundedRectSliderTrackShape(),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: value,
                min: 0,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    return color.toHex().substring(1).toUpperCase();
  }

  Color? _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return null;
  }

  void _setColor(Color color) {
    setState(() {
      _currentColor = color;
      _hexController.text = _colorToHex(color);
    });
    widget.onColorSelected(color);
  }

  void _updateColorFromHSV() {
    final color = HSVColor.fromAHSV(
      widget.showOpacity ? _opacity : 1.0,
      _hue,
      _saturation,
      _value,
    ).toColor();
    _setColor(color);
  }

  void _updateFilteredColors() {
    _filteredColors = YoColorPresets.byPalette(_selectedPalette);
  }

  void _updateHSVFromColor(Color color) {
    final hsv = HSVColor.fromColor(color);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }
}

/// Extension on Color for utility methods
extension _YoColorExtension on Color {
  /// Get contrast color (black or white) based on luminance
  Color get contrastColor {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Convert color to hex string (e.g., "#FF2196F3")
  String toHex({bool withAlpha = true}) {
    if (withAlpha) {
      return '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    }
    return '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
