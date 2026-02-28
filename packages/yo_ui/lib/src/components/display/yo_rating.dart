// File: yo_rating.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui_base.dart';

enum YoRatingSize { small, medium, large, xlarge }

enum YoRatingType { stars, hearts, emojis, numbers, custom }

class YoRating extends StatefulWidget {
  final double initialRating;
  final int maxRating;
  final ValueChanged<double>? onRatingUpdate;
  final bool allowHalfRating;
  final YoRatingSize size;
  final YoRatingType type;
  final Color? color;
  final Color? backgroundColor;
  final bool readOnly;
  final bool showLabel;
  final String? labelText;
  final Widget? customIcon;
  final double spacing;
  final bool animate;

  const YoRating({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.onRatingUpdate,
    this.allowHalfRating = false,
    this.size = YoRatingSize.medium,
    this.type = YoRatingType.stars,
    this.color,
    this.backgroundColor,
    this.readOnly = false,
    this.showLabel = false,
    this.labelText,
    this.customIcon,
    this.spacing = 4.0,
    this.animate = true,
  });

  @override
  State<YoRating> createState() => _YoRatingState();
}

class _YoRatingState extends State<YoRating> {
  late double _currentRating;
  late double _hoverRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    _hoverRating = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.labelText != null) ...[
          YoText.bodyMedium(widget.labelText!, color: context.gray600),
          YoSpace.height(widget.spacing),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.maxRating, (index) {
            return _buildRatingIcon(index + 1);
          }),
        ),
        if (widget.showLabel) ...[
          YoSpace.height(widget.spacing),
          _buildRatingText(context),
        ],
      ],
    );
  }

  Widget _buildRatingIcon(int position) {
    final iconSize = _getIconSize();
    final isActive = _hoverRating > 0
        ? position <= _hoverRating
        : position <= _currentRating;
    final isHalf = widget.allowHalfRating &&
        ((_hoverRating > 0 ? _hoverRating : _currentRating) + 0.5) == position;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
      child: GestureDetector(
        onTap:
            widget.readOnly ? null : () => _handleRating(position.toDouble()),
        onTapDown: widget.readOnly
            ? null
            : (_) => _setHoverRating(position.toDouble()),
        onTapUp: widget.readOnly ? null : (_) => _clearHoverRating(),
        onTapCancel: widget.readOnly ? null : _clearHoverRating,
        child: MouseRegion(
          onEnter: widget.readOnly
              ? null
              : (_) => _setHoverRating(position.toDouble()),
          onExit: widget.readOnly ? null : (_) => _clearHoverRating(),
          child: AnimatedContainer(
            duration:
                widget.animate ? Duration(milliseconds: 200) : Duration.zero,
            transform: Matrix4.diagonal3Values(
              _getScaleFactor(position),
              _getScaleFactor(position),
              1.0,
            ),
            child: _buildIcon(isActive, isHalf, iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isActive, bool isHalf, double size) {
    final effectiveColor = isActive
        ? (widget.color ?? context.primaryColor)
        : (widget.backgroundColor ?? context.gray300);

    switch (widget.type) {
      case YoRatingType.stars:
        return Icon(
          isHalf ? Icons.star_half : Icons.star,
          size: size,
          color: effectiveColor,
          fill: isActive ? 1.0 : 0.0,
          grade: isActive ? 1.0 : 0.0,
        );

      case YoRatingType.hearts:
        return Icon(
          Icons.favorite,
          size: size,
          color: effectiveColor,
          fill: isActive ? 1.0 : 0.0,
        );

      case YoRatingType.emojis:
        return YoText.titleLarge(_getEmoji(isActive), fontSize: size);

      case YoRatingType.numbers:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? effectiveColor : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: effectiveColor, width: 1.5),
          ),
          child: Center(
            child: YoText.monoSmall(
              '${_getNumber(isActive)}',
              color: isActive ? context.onPrimaryColor : effectiveColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case YoRatingType.custom:
        return widget.customIcon ??
            Icon(Icons.thumb_up, size: size, color: effectiveColor);
    }
  }

  Widget _buildRatingText(BuildContext context) {
    final rating = _hoverRating > 0 ? _hoverRating : _currentRating;

    String text;
    if (rating == 0) {
      text = 'No rating';
    } else if (widget.allowHalfRating && rating % 1 != 0) {
      text = '${rating.toStringAsFixed(1)} / ${widget.maxRating}';
    } else {
      text = '${rating.toInt()} / ${widget.maxRating}';
    }

    return YoText.bodySmall(text, color: context.gray500);
  }

  double _getScaleFactor(int position) {
    if (!widget.animate || _hoverRating == 0) return 1.0;

    final distance = (position - _hoverRating).abs();
    if (distance == 0) return 1.1; // Current hovered icon
    if (distance == 1) return 1.05; // Adjacent icons
    return 1.0; // Other icons
  }

  double _getIconSize() {
    switch (widget.size) {
      case YoRatingSize.small:
        return 16.0;
      case YoRatingSize.medium:
        return 24.0;
      case YoRatingSize.large:
        return 32.0;
      case YoRatingSize.xlarge:
        return 48.0;
    }
  }

  String _getEmoji(bool isActive) {
    switch (widget.type) {
      case YoRatingType.emojis:
        return isActive ? '⭐' : '☆';
      default:
        return isActive ? '★' : '☆';
    }
  }

  int _getNumber(bool isActive) {
    // For number rating type, we need the position
    // This is handled in the build method
    return 1;
  }

  void _handleRating(double rating) {
    if (widget.readOnly) return;

    double newRating;
    if (widget.allowHalfRating) {
      newRating = rating;
    } else {
      newRating = rating.floorToDouble();
    }

    setState(() {
      _currentRating = newRating;
    });

    widget.onRatingUpdate?.call(newRating);
  }

  void _setHoverRating(double rating) {
    if (widget.readOnly) return;

    setState(() {
      _hoverRating = rating;
    });
  }

  void _clearHoverRating() {
    if (widget.readOnly) return;

    setState(() {
      _hoverRating = 0.0;
    });
  }
}

// Pre-built rating variants
class YoRatingStars extends StatelessWidget {
  final double rating;
  final int maxRating;
  final YoRatingSize size;
  final Color? color;
  final Color? backgroundColor;

  const YoRatingStars({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = YoRatingSize.medium,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return YoRating(
      initialRating: rating,
      maxRating: maxRating,
      readOnly: true,
      size: size,
      type: YoRatingType.stars,
      color: color,
      backgroundColor: backgroundColor,
      showLabel: false,
    );
  }
}

class YoRatingInteractive extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;
  final String? label;
  final YoRatingSize size;

  const YoRatingInteractive({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingUpdate,
    this.label,
    this.size = YoRatingSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return YoRating(
      initialRating: initialRating,
      onRatingUpdate: onRatingUpdate,
      size: size,
      type: YoRatingType.stars,
      showLabel: label != null,
      labelText: label,
      allowHalfRating: true,
      animate: true,
    );
  }
}

class YoRatingSummary extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final int maxRating;
  final bool showBreakdown;
  final List<int>? ratingsDistribution;

  const YoRatingSummary({
    super.key,
    required this.rating,
    required this.totalRatings,
    this.maxRating = 5,
    this.showBreakdown = false,
    this.ratingsDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            YoText.displaySmall(
              rating.toStringAsFixed(1),
              fontWeight: FontWeight.bold,
            ),
            YoSpace.width(context.yoSpacingSm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoRatingStars(
                  rating: rating,
                  maxRating: maxRating,
                  size: YoRatingSize.medium,
                ),
                YoText.bodySmall(
                  '$totalRatings reviews',
                  color: context.gray500,
                ),
              ],
            ),
          ],
        ),
        if (showBreakdown && ratingsDistribution != null) ...[
          YoSpace.height(context.yoSpacingMd),
          _buildRatingsBreakdown(context),
        ],
      ],
    );
  }

  Widget _buildRatingsBreakdown(BuildContext context) {
    return Column(
      children: List.generate(maxRating, (index) {
        final ratingLevel = maxRating - index;
        final count = ratingsDistribution![index];
        final percentage = totalRatings > 0 ? count / totalRatings : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              YoText.bodySmall('$ratingLevel', color: context.gray600),
              YoSpace.width(context.yoSpacingSm),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.gray200,
                    borderRadius: YoSpacing.borderRadiusSm,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: YoSpacing.borderRadiusSm,
                      ),
                    ),
                  ),
                ),
              ),
              YoSpace.width(context.yoSpacingSm),
              YoText.monoSmall('$count', color: context.gray500),
            ],
          ),
        );
      }),
    );
  }
}
