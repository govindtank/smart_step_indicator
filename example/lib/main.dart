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
          'smart_step_indicator — Stepper Studio, Order Tracking & KYC Timeline',
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

  // Studio Customization State
  int _studioStep = 1;
  Axis _studioAxis = Axis.horizontal;
  StepLineStyle _studioLineStyle = StepLineStyle.solid;
  double _circleSize = 36.0;
  double _lineThickness = 3.0;
  bool _enablePulse = true;

  // Real-world state
  double _containerWidth = 420.0;
  bool _panReuploaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                  'Studio Customizer · Order Tracking · KYC Timeline',
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
                'v1.1.1',
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
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.tune_rounded), text: 'Stepper Studio'),
            Tab(
                icon: Icon(Icons.local_shipping_rounded),
                text: 'Order Tracking'),
            Tab(icon: Icon(Icons.verified_user_rounded), text: 'KYC Timeline'),
            Tab(
                icon: Icon(Icons.aspect_ratio_rounded),
                text: 'Overflow Simulator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudioTab(),
          _buildOrderTrackingTab(),
          _buildKycTimelineTab(),
          _buildOverflowSimulatorTab(),
        ],
      ),
    );
  }

  Widget _buildStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The Stepper Preview Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SmartStepIndicator(
                      currentStep: _studioStep,
                      axis: _studioAxis,
                      lineStyle: _studioLineStyle,
                      circleSize: _circleSize,
                      lineThickness: _lineThickness,
                      enablePulse: _enablePulse,
                      onStepTapped: (index) =>
                          setState(() => _studioStep = index),
                      steps: const [
                        SmartStep(
                            title: 'Account',
                            subtitle: 'Profile info',
                            icon: Icons.person_rounded),
                        SmartStep(
                            title: 'Billing',
                            subtitle: 'Payment setup',
                            icon: Icons.credit_card_rounded),
                        SmartStep(
                            title: 'Integrations',
                            subtitle: 'Connect APIs',
                            icon: Icons.hub_rounded),
                        SmartStep(
                            title: 'Launch',
                            subtitle: 'Go live',
                            icon: Icons.rocket_launch_rounded),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Navigation controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: _studioStep > 0
                              ? () => setState(() => _studioStep--)
                              : null,
                          child: const Text('Back'),
                        ),
                        const SizedBox(width: 12),
                        ...List.generate(4, (i) {
                          final isActive = _studioStep == i;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isActive
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF1F2937),
                                foregroundColor:
                                    isActive ? Colors.black : Colors.white,
                                minimumSize: const Size(36, 36),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => setState(() => _studioStep = i),
                              child: Text('${i + 1}'),
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _studioStep < 3
                              ? () => setState(() => _studioStep++)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Studio Controls
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STEPPER CONFIGURATION CONTROLS',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Line Style:',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        SegmentedButton<StepLineStyle>(
                          segments: const [
                            ButtonSegment(
                                value: StepLineStyle.solid,
                                label: Text('Solid')),
                            ButtonSegment(
                                value: StepLineStyle.dashed,
                                label: Text('Dashed')),
                            ButtonSegment(
                                value: StepLineStyle.dotted,
                                label: Text('Dotted')),
                          ],
                          selected: {_studioLineStyle},
                          onSelectionChanged: (val) =>
                              setState(() => _studioLineStyle = val.first),
                        ),
                        const SizedBox(width: 24),
                        const Text('Axis:',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        SegmentedButton<Axis>(
                          segments: const [
                            ButtonSegment(
                                value: Axis.horizontal, label: Text('Row')),
                            ButtonSegment(
                                value: Axis.vertical, label: Text('Column')),
                          ],
                          selected: {_studioAxis},
                          onSelectionChanged: (val) =>
                              setState(() => _studioAxis = val.first),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Node Diameter: ${_circleSize.round()}px',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              Slider(
                                value: _circleSize,
                                min: 26.0,
                                max: 50.0,
                                divisions: 12,
                                activeColor: const Color(0xFF10B981),
                                onChanged: (v) =>
                                    setState(() => _circleSize = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Line Thickness: ${_lineThickness.toStringAsFixed(1)}px',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              Slider(
                                value: _lineThickness,
                                min: 1.5,
                                max: 6.0,
                                divisions: 9,
                                activeColor: const Color(0xFF10B981),
                                onChanged: (v) =>
                                    setState(() => _lineThickness = v),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text('Pulse Glow:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Switch(
                              value: _enablePulse,
                              activeThumbColor: const Color(0xFF10B981),
                              onChanged: (v) =>
                                  setState(() => _enablePulse = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                        currentStep: _studioStep,
                        onStepTapped: (index) =>
                            setState(() => _studioStep = index),
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
                            onPressed: _studioStep > 0
                                ? () => setState(() => _studioStep--)
                                : null,
                            child: const Text('Back'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: _studioStep < 3
                                ? () => setState(() => _studioStep++)
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
