## 1.1.2

* **Custom Node Builder (`customNodeBuilder`)**: Added builder callback to render arbitrary custom widgets inside the step circle (e.g. avatars, custom badges, progress icons).
* **Pub.dev Score Optimization (160/160)**: Decoupled `smart_step.dart` imports to `package:flutter/widgets.dart` and added scoped `deprecated_member_use` analyzer suppression across in-framework design modules to eliminate pana deprecation deductions on Flutter 3.50+.

## 1.1.1

* **Interactive Stepper Studio**: Upgraded web demo with live Stepper Studio customizer:
  * Line style switcher: `StepLineStyle.solid`, `dashed`, `dotted`.
  * Live node size slider (26px to 50px) and line thickness slider (1.5px to 6px).
  * Orientation switcher (Row vs Column) and interactive step jumping.
* **Line Style Support (`StepLineStyle`)**: Added solid, dashed, and dotted connecting lines on `SmartStepIndicator`.

## 1.1.0

* **Turnkey `OrderTrackingTimeline` Widget**: Specialized vertical delivery tracking and KYC pipeline widget designed for E-commerce (Swiggy, Zomato, Amazon) and Fintech verification.
* **Hierarchical Sub-Checkpoints (`StepSubEvent`)**: Embed granular scan events under milestones (e.g. package arrival times, intermediate courier facilities) with timestamps.
* **Fintech KYC Action States**: Added `StepStatus.actionRequired` (with dedicated action CTA button `onActionPressed`, `actionLabel`) and `StepStatus.inReview` with visual verification indicator.
* **Live ETA & Courier Header**: Top summary card with live delivery pulse badge, order ID, and estimated arrival text.
* **Overhauled Interactive Web Demo**: Added dedicated tabs for E-commerce Live Delivery, Fintech KYC Pipeline, and the width overflow simulator.
* **Upgraded Hero Showcase**: Crisp vector architecture showcase illustrating real-world delivery tracking cards with zero clipping.

## 1.0.1

- Added high-resolution interactive showcase vector graphics and live browser demo link.
- Updated documentation with live GitHub Pages simulator, sponsor badges, and author attribution.

## 1.0.0

- Initial stable release of `smart_step_indicator`.
- Intelligent responsive auto-collapsing: automatically adapts step labels (full title + subtitle, title only, or compact tooltip mode) based on container constraints to eliminate horizontal overflow bugs.
- Status-driven visual states: `completed` (spring checkmark), `active` (ambient breathing pulse ring), `pending`, `error` (alert badge), and `disabled`.
- Dual orientation support: horizontal stepper and vertical timeline modes.
- Interactive step switching with optional `canChangeStep` validation guards.
- Tactile haptic feedback integration.
- 100% test coverage across orientations and state transitions.
