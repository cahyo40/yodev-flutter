import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Floating Action Button with Speed Dial
class YoFAB extends StatefulWidget {
  final IconData icon;
  final List<YoFABAction> actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final String? heroTag;
  final VoidCallback? onPressed;

  const YoFAB({
    super.key,
    required this.icon,
    this.actions = const [],
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56,
    this.heroTag,
    this.onPressed,
  });

  /// Speed dial FAB with expandable actions
  const YoFAB.speedDial({
    super.key,
    this.icon = Icons.add,
    required this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56,
    this.heroTag,
  }) : onPressed = null;

  @override
  State<YoFAB> createState() => _YoFABState();
}

/// Action item for Speed Dial FAB
class YoFABAction {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const YoFABAction({
    required this.icon,
    this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });
}

class _YoFABState extends State<YoFAB> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    // Simple FAB if no actions or has onPressed
    if (widget.actions.isEmpty || widget.onPressed != null) {
      return FloatingActionButton(
        onPressed: widget.onPressed,
        backgroundColor: widget.backgroundColor ?? context.primaryColor,
        foregroundColor: widget.foregroundColor ?? context.onPrimaryColor,
        heroTag: widget.heroTag,
        child: Icon(widget.icon),
      );
    }

    // Speed Dial FAB
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withAlpha(128),
            ),
          ),

        // Action buttons
        ...List.generate(
          widget.actions.length,
          (index) => ScaleTransition(
            scale: _animation,
            child: Container(
              margin: EdgeInsets.only(
                bottom: (widget.size + 16) * (index + 1),
              ),
              child: _buildActionButton(widget.actions[index]),
            ),
          ),
        ),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor ?? context.primaryColor,
          foregroundColor: widget.foregroundColor ?? context.onPrimaryColor,
          heroTag: widget.heroTag,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(widget.icon),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildActionButton(YoFABAction action) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (action.label != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(context.yoRadiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: YoText.bodySmall(
              action.label!,
            ),
          ),
          const YoSpace.width(12),
        ],
        FloatingActionButton.small(
          onPressed: () {
            action.onTap();
            _toggle();
          },
          backgroundColor: action.backgroundColor ?? context.primaryColor,
          foregroundColor: action.foregroundColor ?? context.onPrimaryColor,
          child: Icon(action.icon, size: 20),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
