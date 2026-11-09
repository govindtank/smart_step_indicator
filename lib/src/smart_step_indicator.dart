import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'smart_step.dart';

/// A responsive, overflow-proof step indicator and timeline stepper for Flutter.
///
/// Automatically monitors available container width and adapts label display
/// (full title, compact, or tooltip-only) to eliminate horizontal overflow
/// bugs on smaller mobile devices.
class SmartStepIndicator extends StatefulWidget {
  /// Creates a responsive step indicator.
  const SmartStepIndicator({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.axis = Axis.horizontal,
    this.onStepTapped,
    this.canChangeStep,
    this.activeColor = const Color(0xFF3B82F6),
    this.completedColor = const Color(0xFF10B981),
    this.pendingColor = const Color(0xFF64748B),
    this.errorColor = const Color(0xFFEF4444),
    this.circleSize = 36.0,
    this.lineThickness = 3.0,
    this.enablePulse = true,
    this.responsiveMode = StepResponsiveMode.auto,
    this.enableHaptics = true,
  })  : assert(circleSize > 0, 'circleSize must be positive'),
        assert(lineThickness > 0, 'lineThickness must be positive');

  /// The list of steps to display.
  final List<SmartStep> steps;

  /// The zero-based index of the currently active step. Defaults to 0.
  final int currentStep;

  /// Layout orientation of the stepper. Defaults to [Axis.horizontal].
  final Axis axis;

  /// Callback fired when a step circle is tapped.
  final ValueChanged<int>? onStepTapped;

  /// Optional guard predicate determining if step navigation is permitted.
  final bool Function(int from, int to)? canChangeStep;

  /// Color used for the active step and pulse effect.
  final Color activeColor;

  /// Color used for completed steps and checkmarks.
  final Color completedColor;

  /// Color used for unreached pending steps and lines.
  final Color pendingColor;

  /// Color used for failed or error steps.
  final Color errorColor;

  /// Diameter of the circular step indicator nodes. Defaults to 36.0.
  final double circleSize;

  /// Thickness of the connector lines between steps. Defaults to 3.0.
  final double lineThickness;

  /// Whether to play a subtle ambient pulse ring on the active step. Defaults to true.
  final bool enablePulse;

  /// How labels adapt to available space. Defaults to [StepResponsiveMode.auto].
  final StepResponsiveMode responsiveMode;

  /// Whether to produce tactile haptic feedback on step taps. Defaults to true.
  final bool enableHaptics;

  @override
  State<SmartStepIndicator> createState() => _SmartStepIndicatorState();
}

class _SmartStepIndicatorState extends State<SmartStepIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SmartStepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePulse != oldWidget.enablePulse) {
      if (widget.enablePulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  StepStatus _resolveStatus(int index) {
    final step = widget.steps[index];
    if (step.status != null) return step.status!;
    if (index < widget.currentStep) return StepStatus.completed;
    if (index == widget.currentStep) return StepStatus.active;
    return StepStatus.pending;
  }

  void _onStepTap(int targetIndex) {
    if (widget.onStepTapped == null) return;
    if (widget.canChangeStep != null &&
        !widget.canChangeStep!(widget.currentStep, targetIndex)) {
      return;
    }
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    widget.onStepTapped!(targetIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.axis == Axis.vertical) {
          return _buildVerticalStepper();
        }
        return _buildHorizontalStepper(constraints.maxWidth);
      },
    );
  }

  Widget _buildHorizontalStepper(double availableWidth) {
    final stepCount = widget.steps.length;
    final slotWidth = availableWidth / (stepCount > 0 ? stepCount : 1);

    // Responsive determination
    final bool showSubtitle;
    final bool showTitle;

    switch (widget.responsiveMode) {
      case StepResponsiveMode.alwaysFull:
        showTitle = true;
        showSubtitle = true;
        break;
      case StepResponsiveMode.compact:
        showTitle = false;
        showSubtitle = false;
        break;
      case StepResponsiveMode.auto:
        showTitle = slotWidth >= 75.0;
        showSubtitle = slotWidth >= 120.0;
        break;
    }

    final children = <Widget>[];

    for (int i = 0; i < stepCount; i++) {
      final status = _resolveStatus(i);
      final step = widget.steps[i];

      // Build Step Node with labels
      final node = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircleNode(i, status),
          if (showTitle) ...[
            const SizedBox(height: 8),
            Text(
              step.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: status == StepStatus.active
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: _getTextColor(status),
              ),
            ),
          ],
          if (showSubtitle && step.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              step.subtitle!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: _getTextColor(status).withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      );

      final wrappedNode = Tooltip(
        message:
            '${step.title}${step.subtitle != null ? " • ${step.subtitle}" : ""}',
        child: InkWell(
          onTap: status != StepStatus.disabled ? () => _onStepTap(i) : null,
          borderRadius: BorderRadius.circular(widget.circleSize),
          child: node,
        ),
      );

      children.add(
        Expanded(
          child: wrappedNode,
        ),
      );

      // Add connecting line between steps (not after the last step)
      if (i < stepCount - 1) {
        final nextStatus = _resolveStatus(i + 1);
        final isLineCompleted = status == StepStatus.completed &&
            (nextStatus == StepStatus.completed ||
                nextStatus == StepStatus.active);

        children.add(
          Expanded(
            child: Container(
              height: widget.lineThickness,
              margin: EdgeInsets.only(
                bottom: showTitle ? (showSubtitle ? 28.0 : 20.0) : 0.0,
              ),
              decoration: BoxDecoration(
                color: isLineCompleted
                    ? widget.completedColor
                    : widget.pendingColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(widget.lineThickness),
              ),
            ),
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildVerticalStepper() {
    final stepCount = widget.steps.length;
    final items = <Widget>[];

    for (int i = 0; i < stepCount; i++) {
      final status = _resolveStatus(i);
      final step = widget.steps[i];
      final isLast = i == stepCount - 1;

      items.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildCircleNode(i, status),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: widget.lineThickness,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: status == StepStatus.completed
                            ? widget.completedColor
                            : widget.pendingColor.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: status == StepStatus.active
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: _getTextColor(status),
                        ),
                      ),
                      if (step.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                _getTextColor(status).withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }

  Widget _buildCircleNode(int index, StepStatus status) {
    final step = widget.steps[index];
    final color = _getStatusColor(status);

    Widget innerContent;
    if (status == StepStatus.completed) {
      innerContent = const Icon(Icons.check, color: Colors.white, size: 18);
    } else if (status == StepStatus.error) {
      innerContent = const Icon(Icons.close, color: Colors.white, size: 18);
    } else if (step.icon != null) {
      innerContent = Icon(step.icon, color: Colors.white, size: 18);
    } else {
      innerContent = Text(
        '${index + 1}',
        style: TextStyle(
          color: status == StepStatus.pending ? color : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: widget.circleSize,
      height: widget.circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == StepStatus.pending ? Colors.transparent : color,
        border: Border.all(
          color: color,
          width: status == StepStatus.active ? 2.5 : 2.0,
        ),
        boxShadow: status == StepStatus.active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(child: innerContent),
    );

    if (status == StepStatus.active && widget.enablePulse) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseVal = _pulseController.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.circleSize + (pulseVal * 12.0),
                height: widget.circleSize + (pulseVal * 12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: (1.0 - pulseVal) * 0.25),
                ),
              ),
              circle,
            ],
          );
        },
      );
    }

    return circle;
  }

  Color _getStatusColor(StepStatus status) {
    switch (status) {
      case StepStatus.active:
        return widget.activeColor;
      case StepStatus.completed:
        return widget.completedColor;
      case StepStatus.error:
        return widget.errorColor;
      case StepStatus.pending:
        return widget.pendingColor;
      case StepStatus.disabled:
        return widget.pendingColor.withValues(alpha: 0.4);
    }
  }

  Color _getTextColor(StepStatus status) {
    switch (status) {
      case StepStatus.active:
        return widget.activeColor;
      case StepStatus.completed:
        return widget.completedColor;
      case StepStatus.error:
        return widget.errorColor;
      case StepStatus.pending:
      case StepStatus.disabled:
        return widget.pendingColor;
    }
  }
}
