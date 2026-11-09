# smart_step_indicator

[![Pub Version](https://img.shields.io/pub/v/smart_step_indicator)](https://pub.dev/packages/smart_step_indicator)
[![Pub Points](https://img.shields.io/pub/points/smart_step_indicator)](https://pub.dev/packages/smart_step_indicator/score)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Donate-orange.svg)](https://buymeacoffee.com/govindtanko)
[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-ff69b4.svg)](https://github.com/sponsors/govindtank)

A responsive, overflow-proof step indicator and timeline stepper for Flutter. Automatically adapts and collapses labels to prevent yellow/black horizontal overflow errors on narrow screens, featuring ambient pulse rings for active steps and animated status morphing.

---

## ✨ Features

- **🛡️ 100% Overflow-Proof:** Automatically measures available screen width. If step labels would cause horizontal overflow on mobile screens or split-view devices, it dynamically collapses labels into clean badge tooltips.
- **💫 Status-Driven Morphing:** Supports `completed` (spring checkmark), `active` (ambient breathing pulse ring), `pending`, `error` (alert badge), and `disabled` states.
- **🔄 Dual Orientation:** Seamlessly switches between horizontal checkout wizards and vertical delivery tracking timelines.
- **👆 Interactive Navigation:** Tap to navigate between steps with optional validation guards (`canChangeStep: (from, to) => bool`).
- **📳 Tactile Haptic Feedback:** Triggers subtle haptic feedback on step selection.
- **📦 Zero External Dependencies:** Pure Flutter implementation. Full compatibility across Android, iOS, Web, macOS, Windows, and Linux.

---

## 🚀 Getting Started

Add `smart_step_indicator` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_step_indicator: ^1.0.0
```

Import the package:

```dart
import 'package:smart_step_indicator/smart_step_indicator.dart';
```

---

## 💡 Usage

### 1. Interactive Form Stepper

```dart
SmartStepIndicator(
  currentStep: currentStep,
  onStepTapped: (index) => setState(() => currentStep = index),
  steps: const [
    SmartStep(title: 'Account', subtitle: 'Credentials'),
    SmartStep(title: 'Profile', subtitle: 'Personal info'),
    SmartStep(title: 'Security', subtitle: '2FA Setup'),
    SmartStep(title: 'Confirm', subtitle: 'Review'),
  ],
)
```

### 2. Vertical Order Timeline

```dart
SmartStepIndicator(
  axis: Axis.vertical,
  currentStep: 2,
  steps: const [
    SmartStep(title: 'Order Placed', subtitle: '10:14 AM', icon: Icons.receipt_long),
    SmartStep(title: 'Dispatched', subtitle: 'FedEx #94001', icon: Icons.local_shipping),
    SmartStep(title: 'Out for Delivery', subtitle: 'Arriving today', icon: Icons.delivery_dining),
    SmartStep(title: 'Delivered', subtitle: 'Pending', icon: Icons.check_circle_outline),
  ],
)
```

---

## ⚙️ Configuration

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `steps` | `List<SmartStep>` | *required* | The list of step data definitions. |
| `currentStep` | `int` | `0` | Zero-based index of the currently active step. |
| `axis` | `Axis` | `.horizontal` | Orientation: `.horizontal` or `.vertical`. |
| `onStepTapped` | `ValueChanged<int>?` | `null` | Callback fired when an enabled step is clicked. |
| `canChangeStep` | `bool Function(int, int)?` | `null` | Predicate guard before allowing navigation. |
| `activeColor` | `Color` | `Color(0xFF3B82F6)` | Color for active step and ambient glow ring. |
| `completedColor` | `Color` | `Color(0xFF10B981)` | Color for completed checkmarks and lines. |
| `errorColor` | `Color` | `Color(0xFFEF4444)` | Color for error status steps. |
| `circleSize` | `double` | `36.0` | Node diameter in logical pixels. |
| `enablePulse` | `bool` | `true` | Plays ambient pulsing ring around the active step. |
| `responsiveMode` | `StepResponsiveMode` | `.auto` | `.auto`, `.alwaysFull`, or `.compact`. |

---

## 🧪 Testing

Run package tests:

```bash
flutter test
```

---

## 📄 License

Licensed under the [Apache 2.0 License](LICENSE).
