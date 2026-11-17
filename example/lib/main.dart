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
      title:
          'smart_step_indicator — Live Order Tracking & KYC Timeline Stepper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF111827),
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

class _StepperHomeScreenState extends State<StepperHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 1;
  double _containerWidth = 420.0;
  bool _panReuploaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.linear_scale_rounded,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'smart_step_indicator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Live Order Tracking · Sub-Checkpoints · KYC Stepper',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'v1.2.0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF10B981),
          indicatorWeight: 3,
          labelColor: const Color(0xFF10B981),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
                icon: Icon(Icons.local_shipping_rounded),
                text: 'E-Commerce Tracking'),
            Tab(
                icon: Icon(Icons.verified_user_rounded),
                text: 'Fintech KYC Timeline'),
            Tab(icon: Icon(Icons.tune_rounded), text: 'Overflow Simulator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderTrackingTab(),
          _buildKycTimelineTab(),
          _buildOverflowSimulatorTab(),
        ],
      ),
    );
  }

  Widget _buildOrderTrackingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OrderTrackingTimeline(
                orderId: 'DEL-849201',
                etaTitle: 'Estimated Delivery Today by 8:30 PM',
                etaSubtitle:
                    'Courier: Express Surface Freight • Out with Driver',
                currentStep: 2,
                steps: const [
                  SmartStep(
                    title: 'Order Placed & Confirmed',
                    subtitle: 'Seller verified transaction and packed parcel',
                  ),
                  SmartStep(
                    title: 'Dispatched & In-Transit',
                    subtitle: 'Package moving through distribution line',
                    subEvents: [
                      StepSubEvent(
                        title: 'Departed Bhiwandi Sorting Facility',
                        timestamp: 'Nov 17, 08:30 AM',
                      ),
                      StepSubEvent(
                        title: 'Arrived at Bengaluru Central Logistics Hub',
                        timestamp: 'Nov 17, 02:45 PM',
                      ),
                      StepSubEvent(
                        title: 'Sorted and Dispatched to Local Delivery Center',
                        timestamp: 'Nov 17, 05:10 PM',
                      ),
                    ],
                  ),
                  SmartStep(
                    title: 'Out for Delivery',
                    subtitle: 'Driver Rajesh K. is 1.8 km away in your area',
                    etaBadge: '18 mins left',
                  ),
                  SmartStep(
                    title: 'Delivered to Doorstep',
                    subtitle: 'OTP verification required upon handover',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKycTimelineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OrderTrackingTimeline(
                orderId: 'KYC-IN-49201',
                etaTitle: 'Bank Account & KYC Verification Pipeline',
                etaSubtitle: 'RBI compliant account onboarding workflow',
                currentStep: 1,
                steps: [
                  const SmartStep(
                    title: 'Aadhaar e-KYC Verification',
                    subtitle: 'OTP authentication verified via UIDAI',
                    status: StepStatus.completed,
                  ),
                  SmartStep(
                    title: 'PAN Card Validation',
                    subtitle: _panReuploaded
                        ? 'New document submitted • Processing OCR'
                        : 'Image blurry • Failed automatic name match',
                    status: _panReuploaded
                        ? StepStatus.inReview
                        : StepStatus.actionRequired,
                    actionLabel:
                        _panReuploaded ? null : 'Re-upload Clear Photo',
                    onActionPressed: () {
                      setState(() => _panReuploaded = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Document re-uploaded. Sent for review.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SmartStep(
                    title: 'Bank Account Penny Drop Check',
                    subtitle:
                        'Verifying beneficiary name via IMPS ₹1.00 deposit',
                    status: StepStatus.pending,
                  ),
                  const SmartStep(
                    title: 'Video In-Person Verification (V-CIP)',
                    subtitle:
                        'Live 2-minute agent call to finalize account opening',
                    status: StepStatus.pending,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverflowSimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Container Width: ${_containerWidth.round()}px (Drag to test Auto-Collapse)',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Labels smoothly collapse into compact dots on narrow screens with 0 overflow exceptions.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Slider(
                      value: _containerWidth,
                      min: 240.0,
                      max: 600.0,
                      divisions: 36,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) => setState(() => _containerWidth = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _containerWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFF10B981).withAlpha(100)),
                  ),
                  child: Column(
                    children: [
                      SmartStepIndicator(
                        currentStep: _currentStep,
                        onStepTapped: (index) =>
                            setState(() => _currentStep = index),
                        steps: const [
                          SmartStep(
                              title: 'Cart Review', subtitle: 'Review items'),
                          SmartStep(
                              title: 'Address', subtitle: 'Delivery address'),
                          SmartStep(title: 'Payment', subtitle: 'UPI / Card'),
                          SmartStep(title: 'Receipt', subtitle: 'Order placed'),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.black,
                            ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
