import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Stepper step model
class YoStep {
  final String title;
  final String? subtitle;
  final Widget content;
  final YoStepState state;
  final bool isActive;

  const YoStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = YoStepState.indexed,
    this.isActive = false,
  });
}

/// Multi-step wizard/stepper widget
class YoStepper extends StatefulWidget {
  final List<YoStep> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final YoStepperType type;
  final Widget? continueButton;
  final Widget? cancelButton;
  final Color? activeColor;
  final Color? inactiveColor;

  const YoStepper({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.type = YoStepperType.vertical,
    this.continueButton,
    this.cancelButton,
    this.activeColor,
    this.inactiveColor,
  }) : assert(currentStep >= 0 && currentStep < steps.length);

  @override
  State<YoStepper> createState() => _YoStepperState();
}

/// Stepper type enum
enum YoStepperType {
  vertical,
  horizontal,
}

/// Step state enum
enum YoStepState {
  indexed,
  editing,
  complete,
  disabled,
  error,
}

class _YoStepperState extends State<YoStepper> {
  @override
  Widget build(BuildContext context) {
    return widget.type == YoStepperType.vertical
        ? _buildVerticalStepper()
        : _buildHorizontalStepper();
  }

  Widget _buildHorizontalStepper() {
    return Column(
      children: [
        Row(
          children: List.generate(
            widget.steps.length * 2 - 1,
            (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final step = widget.steps[stepIndex];
                final isActive = stepIndex == widget.currentStep;
                final isCompleted = stepIndex < widget.currentStep;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onStepTapped?.call(stepIndex),
                    child: Column(
                      children: [
                        _buildStepCircle(
                            stepIndex, isActive, isCompleted, step.state),
                        const SizedBox(height: 8),
                        Text(
                          step.title,
                          style: context.yoBodySmall.copyWith(
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final stepIndex = index ~/ 2;
                final isCompleted = stepIndex < widget.currentStep;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? (widget.activeColor ?? context.primaryColor)
                        : (widget.inactiveColor ?? context.gray300),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        widget.steps[widget.currentStep].content,
        const SizedBox(height: 16),
        Row(
          children: [
            if (widget.onStepContinue != null)
              Expanded(
                child: widget.continueButton ??
                    YoButton(
                      text: widget.currentStep == widget.steps.length - 1
                          ? 'Finish'
                          : 'Continue',
                      variant: YoButtonVariant.primary,
                      onPressed: widget.onStepContinue,
                    ),
              ),
            if (widget.onStepCancel != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: widget.cancelButton ??
                    YoButton(
                      text: 'Cancel',
                      variant: YoButtonVariant.ghost,
                      onPressed: widget.onStepCancel,
                    ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle(
    int index,
    bool isActive,
    bool isCompleted,
    YoStepState state,
  ) {
    final size = 32.0;
    final activeColor = widget.activeColor ?? context.primaryColor;
    final inactiveColor = widget.inactiveColor ?? context.gray300;

    Color backgroundColor;
    Color contentColor;
    Widget content;

    if (state == YoStepState.error) {
      backgroundColor = context.errorColor;
      contentColor = Colors.white;
      content = const Icon(Icons.close, color: Colors.white, size: 16);
    } else if (isCompleted) {
      backgroundColor = activeColor;
      contentColor = Colors.white;
      content = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (isActive) {
      backgroundColor = activeColor;
      contentColor = Colors.white;
      content = Text(
        '${index + 1}',
        style: TextStyle(
          color: contentColor,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      backgroundColor = inactiveColor;
      contentColor = Colors.white;
      content = Text(
        '${index + 1}',
        style: TextStyle(color: contentColor),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: content),
    );
  }

  Widget _buildVerticalStepper() {
    return Column(
      children: List.generate(
        widget.steps.length,
        (index) {
          final step = widget.steps[index];
          final isActive = index == widget.currentStep;
          final isCompleted = index < widget.currentStep;

          return Column(
            children: [
              InkWell(
                onTap: () => widget.onStepTapped?.call(index),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _buildStepCircle(
                            index, isActive, isCompleted, step.state),
                        if (index < widget.steps.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: isCompleted
                                ? (widget.activeColor ?? context.primaryColor)
                                : (widget.inactiveColor ?? context.gray300),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: context.yoBodyLarge.copyWith(
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (step.subtitle != null)
                            Text(
                              step.subtitle!,
                              style: context.yoBodySmall.copyWith(
                                color: context.gray500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 44),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      step.content,
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (widget.onStepContinue != null)
                            widget.continueButton ??
                                YoButton(
                                  text: index == widget.steps.length - 1
                                      ? 'Finish'
                                      : 'Continue',
                                  variant: YoButtonVariant.primary,
                                  onPressed: widget.onStepContinue,
                                ),
                          if (widget.onStepCancel != null) ...[
                            const SizedBox(width: 8),
                            widget.cancelButton ??
                                YoButton(
                                  text: 'Cancel',
                                  variant: YoButtonVariant.ghost,
                                  onPressed: widget.onStepCancel,
                                ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}
