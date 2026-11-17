import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_step_indicator/smart_step_indicator.dart';

void main() {
  group('OrderTrackingTimeline Widget Tests', () {
    testWidgets(
        'renders order tracking timeline with ETA header and sub-events',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrderTrackingTimeline(
              orderId: 'DEL-99218',
              etaTitle: 'Estimated Delivery by 8:30 PM',
              etaSubtitle: 'Courier: Express Logistics',
              currentStep: 2,
              steps: [
                SmartStep(
                  title: 'Order Placed & Confirmed',
                  subtitle: 'Seller has processed your order',
                ),
                SmartStep(
                  title: 'Dispatched from Warehouse',
                  subtitle: 'In transit via ground freight',
                  subEvents: [
                    StepSubEvent(
                      title: 'Departed Mumbai Central Facility',
                      timestamp: 'Today, 10:45 AM',
                    ),
                    StepSubEvent(
                      title: 'Arrived at Bengaluru Hub',
                      timestamp: 'Today, 02:15 PM',
                    ),
                  ],
                ),
                SmartStep(
                  title: 'Out for Delivery',
                  subtitle: 'Delivery executive is nearby',
                  etaBadge: '18 mins',
                ),
                SmartStep(
                  title: 'Delivered',
                  subtitle: 'Package handed over',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('ORDER #DEL-99218'), findsOneWidget);
      expect(find.text('Estimated Delivery by 8:30 PM'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Order Placed & Confirmed'), findsOneWidget);
      expect(find.text('Departed Mumbai Central Facility'), findsOneWidget);
      expect(find.text('Arrived at Bengaluru Hub'), findsOneWidget);
      expect(find.text('Out for Delivery'), findsOneWidget);
      expect(find.text('18 mins'), findsOneWidget);
    });

    testWidgets(
        'renders action button for actionRequired step and triggers callback',
        (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingTimeline(
              steps: [
                const SmartStep(
                  title: 'Aadhaar Verification',
                  status: StepStatus.completed,
                ),
                SmartStep(
                  title: 'PAN Card Verification',
                  subtitle: 'Document image was blurry',
                  status: StepStatus.actionRequired,
                  actionLabel: 'Re-upload Document',
                  onActionPressed: () {
                    actionTriggered = true;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Re-upload Document'), findsOneWidget);

      await tester.tap(find.text('Re-upload Document'));
      await tester.pump();

      expect(actionTriggered, isTrue);
    });
  });
}
