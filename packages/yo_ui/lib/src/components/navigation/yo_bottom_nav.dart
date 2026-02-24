import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Item untuk bottom navigation bar
class YoNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badge;
  final Color? badgeColor;

  const YoNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
    this.badgeColor,
  });
}

/// Animated Bottom Navigation Bar dengan maksimal 5 item
class YoBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final List<YoNavItem> items;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final bool showLabels;
  final Duration animationDuration;
  final Curve animationCurve;

  const YoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.height = 64,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }) : assert(
         items.length >= 2 && items.length <= 5,
         'Items must be between 2 and 5',
       );

  @override
  State<YoBottomNavBar> createState() => _YoBottomNavBarState();
}

class _YoBottomNavBarState extends State<YoBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _controllers[widget.currentIndex].forward();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.items.length,
      (index) =>
          AnimationController(vsync: this, duration: widget.animationDuration),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.animationCurve),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(YoBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? context.backgroundColor;
    final activeClr = widget.activeColor ?? context.primaryColor;
    final inactiveClr = widget.inactiveColor ?? context.gray500;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: YoBoxShadow.elevated(context),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.items.length, (index) {
            return _buildItem(
              context,
              index: index,
              item: widget.items[index],
              isActive: widget.currentIndex == index,
              activeColor: activeClr,
              inactiveColor: inactiveClr,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required int index,
    required YoNavItem item,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final value = _animations[index].value;
            final color = Color.lerp(inactiveColor, activeColor, value)!;
            final scale = 1.0 + (value * 0.1);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: _buildIcon(context, item, isActive, color),
                ),
                if (widget.showLabels) ...[
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: widget.animationDuration,
                    style: TextStyle(
                      color: color,
                      fontSize: isActive ? 12 : 11,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    YoNavItem item,
    bool isActive,
    Color color,
  ) {
    final iconData = isActive && item.activeIcon != null
        ? item.activeIcon!
        : item.icon;

    Widget iconWidget = Icon(iconData, color: color, size: 24);

    // Add badge if exists
    if (item.badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -4,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: item.badgeColor ?? context.errorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16),
              child: Text(
                item.badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return iconWidget;
  }
}
