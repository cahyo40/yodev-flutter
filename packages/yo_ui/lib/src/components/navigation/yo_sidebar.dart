import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Item untuk sidebar navigation
class YoSidebarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final List<YoSidebarItem>? children;

  const YoSidebarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.children,
  });
}

/// Sidebar yang bisa toggle antara expanded (icon + text) dan collapsed (icon only)
class YoSidebar extends StatefulWidget {
  final List<YoSidebarItem> items;
  final int? selectedIndex;
  final ValueChanged<int>? onItemTap;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final double expandedWidth;
  final double collapsedWidth;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Widget? header;
  final Widget? footer;
  final Duration animationDuration;
  final bool showToggleButton;

  const YoSidebar({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onItemTap,
    this.isExpanded = true,
    this.onExpandedChanged,
    this.expandedWidth = 250,
    this.collapsedWidth = 72,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.header,
    this.footer,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showToggleButton = true,
  });

  @override
  State<YoSidebar> createState() => _YoSidebarState();
}

class _YoSidebarState extends State<YoSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _widthAnimation = Tween<double>(
      begin: widget.collapsedWidth,
      end: widget.expandedWidth,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(YoSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      _isExpanded = widget.isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpandedChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? context.backgroundColor;
    final activeClr = widget.activeColor ?? context.primaryColor;
    final inactiveClr = widget.inactiveColor ?? context.gray600;

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(right: BorderSide(color: context.gray200, width: 1)),
          ),
          child: Column(
            children: [
              // Header
              if (widget.header != null) ...[
                widget.header!,
                const Divider(height: 1),
              ],

              // Toggle Button
              if (widget.showToggleButton) ...[
                _buildToggleButton(context, inactiveClr),
                const YoSpace.height(8),
              ],

              // Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      context,
                      index: index,
                      item: widget.items[index],
                      isActive: widget.selectedIndex == index,
                      activeColor: activeClr,
                      inactiveColor: inactiveClr,
                    );
                  },
                ),
              ),

              // Footer
              if (widget.footer != null) ...[
                const Divider(height: 1),
                widget.footer!,
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(BuildContext context, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: _isExpanded ? Alignment.centerRight : Alignment.center,
        child: IconButton(
          onPressed: _toggleExpanded,
          icon: AnimatedRotation(
            turns: _isExpanded ? 0 : 0.5,
            duration: widget.animationDuration,
            child: Icon(Icons.chevron_left, color: iconColor),
          ),
          tooltip: _isExpanded ? 'Collapse' : 'Expand',
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required int index,
    required YoSidebarItem item,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final color = isActive ? activeColor : inactiveColor;
    final iconData =
        isActive && item.activeIcon != null ? item.activeIcon! : item.icon;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.yoRadiusMd),
        child: InkWell(
          onTap: () {
            item.onTap?.call();
            widget.onItemTap?.call(index);
          },
          borderRadius: BorderRadius.circular(context.yoRadiusMd),
          child: AnimatedContainer(
            duration: widget.animationDuration,
            padding: EdgeInsets.symmetric(
              horizontal: _isExpanded ? 12 : 0,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isActive ? activeColor.withAlpha(26) : Colors.transparent,
              borderRadius: BorderRadius.circular(context.yoRadiusMd),
            ),
            child: Row(
              mainAxisAlignment: _isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                _buildIcon(context, iconData, color, item),
                if (_isExpanded) ...[
                  const YoSpace.width(12),
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _isExpanded ? 1.0 : 0.0,
                      duration: widget.animationDuration,
                      child: YoText(
                        item.label,
                        style: TextStyle(
                          color: color,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Badge (only when expanded)
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.badgeColor ?? context.errorColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: YoText(
                        item.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Chevron for children
                  if (item.children != null && item.children!.isNotEmpty)
                    Icon(Icons.chevron_right, color: inactiveColor, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    IconData iconData,
    Color color,
    YoSidebarItem item,
  ) {
    Widget iconWidget = Icon(iconData, color: color, size: 22);

    // Badge indicator when collapsed
    if (!_isExpanded && item.badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: item.badgeColor ?? context.errorColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    return iconWidget;
  }
}
