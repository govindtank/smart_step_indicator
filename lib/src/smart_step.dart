import 'package:flutter/material.dart';

/// Current lifecycle status of an individual step.
enum StepStatus {
  /// Step is upcoming and not yet reached.
  pending,

  /// Step is currently in progress.
  active,

  /// Step was successfully completed.
  completed,

  /// Step encountered an error, rejection, or failure.
  error,

  /// Step requires user action (e.g. document re-upload, KYC biometric check).
  actionRequired,

  /// Step is currently under verification or manual review.
  inReview,

  /// Step is locked or disabled.
  disabled,
}

/// A granular sub-event or milestone under a main step (e.g. package tracking scans).
@immutable
class StepSubEvent {
  /// Creates a sub-event milestone.
  const StepSubEvent({
    required this.title,
    this.timestamp,
    this.description,
    this.isCompleted = true,
  });

  /// The milestone description (e.g. "Arrived at Local Distribution Center").
  final String title;

  /// Optional scan time or date (e.g. "Today, 10:45 AM").
  final String? timestamp;

  /// Optional detail notes (e.g. "Facility: Mumbai Hub #4").
  final String? description;

  /// Whether this sub-event is completed.
  final bool isCompleted;
}

/// Responsive display mode for step labels and titles.
enum StepResponsiveMode {
  /// Automatically adapts label visibility based on container width.
  auto,

  /// Always displays full title and subtitle regardless of screen width.
  alwaysFull,

  /// Displays only step indicator circles, omitting text labels.
  compact,
}

/// Visual presentation style of the connecting line between stepper nodes.
enum StepLineStyle {
  /// Solid continuous line.
  solid,

  /// Dashed line with repeating dash intervals.
  dashed,

  /// Dotted line with small circular dots.
  dotted,
}

/// Data definition for an individual step in [SmartStepIndicator].
class SmartStep {
  /// Creates a step definition.
  const SmartStep({
    required this.title,
    this.subtitle,
    this.icon,
    this.status,
    this.customBadge,
    this.etaBadge,
    this.subEvents = const [],
    this.actionLabel,
    this.onActionPressed,
  });

  /// Primary title of the step.
  final String title;

  /// Optional subtitle or detail text.
  final String? subtitle;

  /// Optional custom icon displayed inside the circle.
  final IconData? icon;

  /// Explicit status override. If null, status is automatically inferred
  /// from the parent stepper's `currentStep` index.
  final StepStatus? status;

  /// Optional custom badge widget displayed next to the circle.
  final Widget? customBadge;

  /// Optional ETA or live status badge text (e.g. "ETA 18m" or "Live").
  final String? etaBadge;

  /// Hierarchical sub-checkpoints under this step (e.g. delivery scans).
  final List<StepSubEvent> subEvents;

  /// Label for action button when [status] is [StepStatus.actionRequired].
  final String? actionLabel;

  /// Callback when user taps the action button on an [StepStatus.actionRequired] step.
  final VoidCallback? onActionPressed;
}
