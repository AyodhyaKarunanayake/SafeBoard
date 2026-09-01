import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/journey_provider.dart';
import '../../providers/booking_provider.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';
import '../../widgets/bus_diagram.dart';
import '../../widgets/qr_code_widget.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class AllocationResultScreen extends StatelessWidget {
  const AllocationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journeyProvider = Provider.of<JourneyProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    final alloc = journeyProvider.currentAllocation ?? bookingProvider.lastAllocation;
    final seatNumber = alloc?.seatNumber ?? '3A';
    final qrData = alloc?.qrCode ?? 'SB-JRN_138_001-3A-alloc_001';
    final boarding = alloc?.boardingStop ?? 'Pettah Main Bus Stand';
    final alighting = alloc?.alightingStop ?? 'NSBM Green University Campus';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Allocation Confirmed'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pink Zone Banner at top
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.priorityBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.priorityAccent.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.priorityAccent.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Priority Zone · Row 3',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.priorityText,
                        ),
                      ),
                      ZonePill(zone: 'priority', small: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seatNumber,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: AppColors.priorityAccent,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Near front door · Left window',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.priorityText,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          QRCodeWidget(data: qrData, size: 76),
                          const SizedBox(height: 4),
                          const Text(
                            'Show to conductor',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.priorityText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Boarding & Alighting Stop Chips Side by Side
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BOARDING',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          boarding,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ALIGHTING',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alighting,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Personalized Safety & Neighbor Context Section ("Who is around you?")
            const Text(
              'Personalized Safety & Neighbor Context',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildWhyRow(
                    Icons.people_outline,
                    AppColors.priorityAccent,
                    'Neighboring Passengers',
                    'Seat 3B: Female passenger boarding at Pettah, alighting at Kilinochchi.',
                  ),
                  const Divider(height: 16),
                  _buildWhyRow(
                    Icons.directions_bus,
                    AppColors.generalAccent,
                    'Conductor Proximity & Oversight',
                    'Situated 2.0 meters from conductor seat with direct front door visibility.',
                  ),
                  const Divider(height: 16),
                  _buildWhyRow(
                    Icons.directions_walk,
                    AppColors.standingAccent,
                    'Standing Passenger Spacing',
                    'Standing passengers restricted to Rows 8-11 (fever-distance buffer of 4.5m from Seat $seatNumber).',
                  ),
                  const Divider(height: 16),
                  _buildWhyRow(
                    Icons.verified_user,
                    Colors.green,
                    'Safety Risk Index',
                    'Calculated Risk Score: 0.05 / 1.0 (Optimal Low-Risk Rating).',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // "Your position on the bus" Section with Custom BusDiagram Widget
            const Text(
              'Your position on the bus',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 10),
            BusDiagram(allocatedSeat: seatNumber),
            const SizedBox(height: 28),

            // Payment Method Selection Card
            const Text(
              'Select Payment Path',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Advance Online Payment (Card / Mobile Wallet)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Pay LKR 1,250 now to instantly guarantee & lock seat', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    value: 'advance_card',
                    groupValue: bookingProvider.paymentMethod,
                    activeColor: AppColors.generalAccent,
                    onChanged: (val) {
                      bookingProvider.setPaymentOptions(method: val!, status: 'paid_online');
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('On-Board QR Payment (Pay When Boarding)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Pay conductor directly on bus via QR scan or cash', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    value: 'onboard_qr',
                    groupValue: bookingProvider.paymentMethod,
                    activeColor: AppColors.generalAccent,
                    onChanged: (val) {
                      bookingProvider.setPaymentOptions(method: val!, status: 'pending_onboard');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons (Confirm & Lock, Request Another Seat, Save QR)
            ElevatedButton.icon(
              onPressed: () {
                journeyProvider.setCurrentAllocation(alloc!);
                context.go('/journey');
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text('Confirm & Lock Seat $seatNumber (${bookingProvider.paymentMethod == 'onboard_qr' ? 'Pay On-Board' : 'Paid'}) →'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final reallocated = await bookingProvider.reallocateSeat(auth.passenger!);
                journeyProvider.setCurrentAllocation(reallocated);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alternative seat ${reallocated.seatNumber} suggested!')),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.priorityAccent,
                side: const BorderSide(color: AppColors.priorityAccent, width: 1.5),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Request another seat suggestion'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code saved to photos / camera roll.')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryNavy,
                side: const BorderSide(color: AppColors.borderLight),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save QR code to photos'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildWhyRow(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
