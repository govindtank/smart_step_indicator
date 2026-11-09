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

  /// Step is locked or disabled.
  disabled,
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

/// Data definition for an individual step in [SmartStepIndicator].
class SmartStep {
  /// Creates a step definition.
  const SmartStep({
    required this.title,
    this.subtitle,
    this.icon,
    this.status,
    this.customBadge,
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
}
