import 'package:flutter/material.dart';
import 'smart_step.dart';

/// A turnkey order tracking and KYC timeline widget for Flutter.
/// Designed for E-commerce (Amazon, Flipkart), Food Delivery (Swiggy, Zomato),
/// and Fintech KYC verification.
class OrderTrackingTimeline extends StatelessWidget {
  /// Creates an [OrderTrackingTimeline].
  const OrderTrackingTimeline({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.orderId,
    this.etaTitle,
    this.etaSubtitle,
    this.activeColor = const Color(0xFF10B981),
    this.completedColor = const Color(0xFF10B981),
    this.pendingColor = const Color(0xFF475569),
    this.actionColor = const Color(0xFFEF4444),
    this.reviewColor = const Color(0xFFF59E0B),
    this.backgroundColor,
    this.showEtaHeader = true,
  });

  /// The list of milestones with optional sub-events.
  final List<SmartStep> steps;

  /// The active milestone index.
  final int currentStep;

  /// Optional tracking/order identifier (e.g. `ORD-892147`).
  final String? orderId;

  /// Primary ETA header text (e.g. "Estimated Delivery by 8:30 PM").
  final String? etaTitle;

  /// Secondary ETA details (e.g. "On time • Courier: Express Hub").
  final String? etaSubtitle;

  /// Color used for active step and pulsing indicators.
  final Color activeColor;

  /// Color used for completed step checkmarks.
  final Color completedColor;

  /// Color used for pending step indicators.
  final Color pendingColor;

  /// Color used for actionRequired / error alerts.
  final Color actionColor;

  /// Color used for inReview / verification states.
  final Color reviewColor;

  /// Custom background color for card wrapper.
  final Color? backgroundColor;

  /// Whether to render the top ETA banner card.
  final bool showEtaHeader;

  StepStatus _resolveStatus(int index, SmartStep step) {
    if (step.status != null) return step.status!;
    if (index < currentStep) return StepStatus.completed;
    if (index == currentStep) return StepStatus.active;
    return StepStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top ETA Header Card
          if (showEtaHeader && (etaTitle != null || orderId != null)) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (orderId != null) ...[
                        Text(
                          'ORDER #$orderId',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (etaTitle != null) ...[
                        Text(
                          etaTitle!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                      if (etaSubtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          etaSubtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: activeColor.withAlpha(35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: activeColor.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: activeColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: theme.colorScheme.outline.withAlpha(40), height: 1),
            const SizedBox(height: 20),
          ],

          // Timeline Items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final status = _resolveStatus(index, step);
              final isLast = index == steps.length - 1;

              return _buildTimelineRow(context, step, status, isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context,
    SmartStep step,
    StepStatus status,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final indicatorColor = _getIndicatorColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Node Icon & Connecting Line
          Column(
            children: [
              _buildNodeIcon(status, indicatorColor),
              if (!isLast) ...[
                Expanded(
                  child: Container(
                    width: 2.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: (status == StepStatus.completed)
                          ? completedColor
                          : pendingColor.withAlpha(60),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: 14),

          // Right Column: Title, Subtitle, ETA, Action Button, Sub-Checkpoints
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: (status == StepStatus.active ||
                                    status == StepStatus.completed)
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: (status == StepStatus.pending)
                                ? theme.colorScheme.onSurface.withAlpha(120)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (step.etaBadge != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: indicatorColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: indicatorColor.withAlpha(80)),
                          ),
                          child: Text(
                            step.etaBadge!,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: indicatorColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (step.subtitle != null && step.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      step.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(140),
                        fontSize: 12,
                      ),
                    ),
                  ],

                  // Action Required Button
                  if (status == StepStatus.actionRequired &&
                      step.actionLabel != null) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: step.onActionPressed,
                      icon: const Icon(Icons.upload_file_rounded, size: 15),
                      label: Text(step.actionLabel!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],

                  // Sub-events (e.g. Courier scans)
                  if (step.subEvents.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withAlpha(120),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: theme.colorScheme.outline.withAlpha(40)),
                      ),
                      child: Column(
                        children: step.subEvents.map((sub) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: sub.isCompleted
                                        ? completedColor
                                        : pendingColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub.title,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      if (sub.timestamp != null) ...[
                                        Text(
                                          sub.timestamp!,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(130),
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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

  Widget _buildNodeIcon(StepStatus status, Color color) {
    switch (status) {
      case StepStatus.completed:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      case StepStatus.active:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(40),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        );
      case StepStatus.actionRequired:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: const Icon(Icons.priority_high_rounded,
              size: 16, color: Colors.white),
        );
      case StepStatus.inReview:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(40),
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(Icons.hourglass_top_rounded, size: 14, color: color),
        );
      case StepStatus.error:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
        );
      case StepStatus.pending:
      case StepStatus.disabled:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(25),
            border: Border.all(color: color.withAlpha(80), width: 1.5),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(120),
              ),
            ),
          ),
        );
    }
  }

  Color _getIndicatorColor(StepStatus status) {
    switch (status) {
      case StepStatus.completed:
        return completedColor;
      case StepStatus.active:
        return activeColor;
      case StepStatus.actionRequired:
      case StepStatus.error:
        return actionColor;
      case StepStatus.inReview:
        return reviewColor;
      case StepStatus.pending:
      case StepStatus.disabled:
        return pendingColor;
    }
  }
}
