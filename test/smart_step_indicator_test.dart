import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_step_indicator/smart_step_indicator.dart';

void main() {
  testWidgets('renders horizontal steps without overflow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: SmartStepIndicator(
              currentStep: 1,
              steps: [
                SmartStep(title: 'Cart', subtitle: 'Review items'),
                SmartStep(title: 'Shipping', subtitle: 'Enter address'),
                SmartStep(title: 'Payment', subtitle: 'Credit card'),
                SmartStep(title: 'Confirmation', subtitle: 'Complete'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify icons/nodes exist
    expect(find.byType(SmartStepIndicator), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget); // Step 0 is completed
  });

  testWidgets('triggers onStepTapped callback when allowed',
      (WidgetTester tester) async {
    int? tappedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: SmartStepIndicator(
              currentStep: 0,
              onStepTapped: (index) => tappedIndex = index,
              steps: const [
                SmartStep(title: 'Step 1'),
                SmartStep(title: 'Step 2'),
                SmartStep(title: 'Step 3'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap step 2
    await tester.tap(find.text('2'));
    await tester.pump();

    expect(tappedIndex, equals(1));
  });

  testWidgets('renders vertical orientation stepper',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            width: 300,
            child: SmartStepIndicator(
              axis: Axis.vertical,
              currentStep: 2,
              steps: [
                SmartStep(title: 'Order Placed', subtitle: '10:00 AM'),
                SmartStep(title: 'Packed', subtitle: '11:30 AM'),
                SmartStep(title: 'Out for Delivery', subtitle: '2:15 PM'),
                SmartStep(title: 'Delivered', subtitle: 'Pending'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Order Placed'), findsOneWidget);
    expect(find.text('Packed'), findsOneWidget);
    expect(find.text('Out for Delivery'), findsOneWidget);
  });
}
