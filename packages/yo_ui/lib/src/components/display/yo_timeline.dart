import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Timeline direction
enum YoTimelineDirection { vertical, horizontal }

/// Timeline event model
class YoTimelineEvent {
  final String title;
  final String? subtitle;
  final String? description;
  final DateTime? date;
  final IconData? icon;
  final Color? color;
  final Widget? customDot;
  final List<Widget>? actions;
  final bool isCompleted;
  final bool isActive;

  const YoTimelineEvent({
    required this.title,
    this.subtitle,
    this.description,
    this.date,
    this.icon,
    this.color,
    this.customDot,
    this.actions,
    this.isCompleted = false,
    this.isActive = false,
  });
}

/// Timeline widget for displaying events in sequence
class YoTimeline extends StatelessWidget {
  final List<YoTimelineEvent> events;
  final YoTimelineDirection direction;
  final Color? lineColor;
  final Color? activeColor;
  final Color? completedColor;
  final double lineWidth;
  final double dotSize;
  final bool showConnector;
  final bool alternating;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const YoTimeline({
    super.key,
    required this.events,
    this.direction = YoTimelineDirection.vertical,
    this.lineColor,
    this.activeColor,
    this.completedColor,
    this.lineWidth = 2.0,
    this.dotSize = 24.0,
    this.showConnector = true,
    this.alternating = false,
    this.padding,
    this.physics,
    this.shrinkWrap = true,
  });

  /// Stepper style timeline
  factory YoTimeline.stepper({
    Key? key,
    required List<YoTimelineEvent> events,
    int currentStep = 0,
    Color? activeColor,
    Color? completedColor,
  }) {
    final steppedEvents = events.asMap().entries.map((e) {
      return YoTimelineEvent(
        title: e.value.title,
        subtitle: e.value.subtitle,
        description: e.value.description,
        icon: e.key < currentStep
            ? Icons.check
            : e.key == currentStep
            ? Icons.circle
            : null,
        isCompleted: e.key < currentStep,
        isActive: e.key == currentStep,
      );
    }).toList();

    return YoTimeline(
      key: key,
      events: steppedEvents,
      activeColor: activeColor,
      completedColor: completedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (direction == YoTimelineDirection.horizontal) {
      return _buildHorizontal(context);
    }
    return _buildVertical(context);
  }

  Widget _buildVertical(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: events.length,
      itemBuilder: (_, i) => _buildVerticalItem(context, events[i], i),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: physics,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (_, i) => _buildHorizontalItem(context, events[i], i),
      ),
    );
  }

  Widget _buildVerticalItem(
    BuildContext context,
    YoTimelineEvent event,
    int index,
  ) {
    final isLast = index == events.length - 1;
    final isLeft = alternating && index.isEven;
    final dotColor = _getDotColor(context, event);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (alternating && !isLeft)
            Expanded(child: _buildContent(context, event)),

          // Timeline indicator
          SizedBox(
            width: dotSize + 16,
            child: Column(
              children: [
                _buildDot(context, event, dotColor),
                if (showConnector && !isLast)
                  Expanded(
                    child: Container(
                      width: lineWidth,
                      color: lineColor ?? context.gray300,
                    ),
                  ),
              ],
            ),
          ),

          if (!alternating || isLeft)
            Expanded(child: _buildContent(context, event)),
        ],
      ),
    );
  }

  Widget _buildHorizontalItem(
    BuildContext context,
    YoTimelineEvent event,
    int index,
  ) {
    final isLast = index == events.length - 1;
    final dotColor = _getDotColor(context, event);

    return SizedBox(
      width: 160,
      child: Column(
        children: [
          // Dot with horizontal connector
          Row(
            children: [
              _buildDot(context, event, dotColor),
              if (showConnector && !isLast)
                Expanded(
                  child: Container(
                    height: lineWidth,
                    color: lineColor ?? context.gray300,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: context.yoBodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.date != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      YoDateFormatter.formatDate(event.date!),
                      style: context.yoBodySmall.copyWith(
                        color: context.gray500,
                      ),
                    ),
                  ],
                  if (event.description != null) ...[
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        event.description!,
                        style: context.yoBodySmall.copyWith(
                          color: context.gray600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context, YoTimelineEvent event, Color color) {
    if (event.customDot != null) return event.customDot!;

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: context.backgroundColor, width: 2),
        boxShadow: [
          if (event.isActive)
            BoxShadow(
              color: color.withAlpha(102),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: event.icon != null
          ? Icon(event.icon, size: dotSize * 0.6, color: context.onPrimaryColor)
          : null,
    );
  }

  Widget _buildContent(BuildContext context, YoTimelineEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Card(
        elevation: event.isActive ? 2 : 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: event.isActive
              ? BorderSide(color: _getDotColor(context, event).withAlpha(128))
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: context.yoBodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (event.subtitle != null)
                          Text(
                            event.subtitle!,
                            style: context.yoBodySmall.copyWith(
                              color: context.gray500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (event.date != null)
                    Text(
                      YoDateFormatter.formatDate(event.date!),
                      style: context.yoBodySmall.copyWith(
                        color: context.gray500,
                      ),
                    ),
                ],
              ),
              if (event.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  style: context.yoBodyMedium.copyWith(color: context.gray600),
                ),
              ],
              if (event.actions != null && event.actions!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: event.actions!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getDotColor(BuildContext context, YoTimelineEvent event) {
    if (event.color != null) return event.color!;
    if (event.isCompleted) return completedColor ?? context.successColor;
    if (event.isActive) return activeColor ?? context.primaryColor;
    return context.gray300;
  }
}
