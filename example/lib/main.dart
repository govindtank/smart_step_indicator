import 'package:flutter/material.dart';
import 'package:smart_step_indicator/smart_step_indicator.dart';

void main() {
  runApp(const StepperShowcaseApp());
}

/// Main showcase application for smart_step_indicator.
class StepperShowcaseApp extends StatelessWidget {
  /// Default constructor.
  const StepperShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Step Indicator Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
      ),
      home: const StepperHomeScreen(),
    );
  }
}

/// Home screen showing interactive stepper examples.
class StepperHomeScreen extends StatefulWidget {
  /// Default constructor.
  const StepperHomeScreen({super.key});

  @override
  State<StepperHomeScreen> createState() => _StepperHomeScreenState();
}

class _StepperHomeScreenState extends State<StepperHomeScreen> {
  int _currentStep = 1;
  double _containerWidth = 420.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Step Indicator'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 28),
                const Text(
                  '1. Responsive Horizontal Stepper (Interactive)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: _containerWidth,
                        child: SmartStepIndicator(
                          currentStep: _currentStep,
                          onStepTapped: (index) =>
                              setState(() => _currentStep = index),
                          steps: const [
                            SmartStep(
                                title: 'Account', subtitle: 'Credentials'),
                            SmartStep(
                                title: 'Profile', subtitle: 'Personal info'),
                            SmartStep(title: 'Security', subtitle: '2FA Setup'),
                            SmartStep(title: 'Review', subtitle: 'Confirm'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _currentStep > 0
                                ? () => setState(() => _currentStep--)
                                : null,
                            child: const Text('Back'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _currentStep < 3
                                ? () => setState(() => _currentStep++)
                                : null,
                            child: const Text('Next Step'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '2. Width Resize Simulation (Test Auto-Collapse)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Container Width: ${_containerWidth.round()}px (Labels auto-collapse smoothly on narrow widths without yellow overflow stripes!)',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                      Slider(
                        value: _containerWidth,
                        min: 240.0,
                        max: 600.0,
                        divisions: 36,
                        onChanged: (val) =>
                            setState(() => _containerWidth = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '3. Order Delivery Timeline (Vertical Mode)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: const SmartStepIndicator(
                    axis: Axis.vertical,
                    currentStep: 2,
                    steps: [
                      SmartStep(
                        title: 'Order Placed',
                        subtitle: 'Received on Nov 9, 10:14 AM',
                        icon: Icons.receipt_long,
                      ),
                      SmartStep(
                        title: 'Dispatched from Hub',
                        subtitle: 'FedEx Tracking #940011',
                        icon: Icons.local_shipping,
                      ),
                      SmartStep(
                        title: 'Out for Delivery',
                        subtitle: 'Courier arriving before 6:00 PM',
                        icon: Icons.delivery_dining,
                      ),
                      SmartStep(
                        title: 'Delivered',
                        subtitle: 'Signature required upon drop-off',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smart Step Indicator',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Responsive, overflow-proof timeline and stepper. Intelligently collapses labels on smaller screens to eliminate overflow exceptions.',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
