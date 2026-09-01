import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class RouteDetailScreen extends StatelessWidget {
  final String routeId;

  const RouteDetailScreen({
    super.key,
    required this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final route = bookingProvider.selectedRoute ?? bookingProvider.sampleRoutes.first;
    final passenger = authProvider.passenger;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Deep Navy Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 56, bottom: 24),
              color: AppColors.primaryNavy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.go('/search'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          route.routeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${route.distanceKm} km · ${route.totalStops} Stops',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${route.startPoint} ➔ ${route.endPoint}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Seat Availability',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Priority Zone Card
                  _buildZoneDetailCard(
                    zone: 'priority',
                    title: 'Priority Zone (Rows 1-3)',
                    desc: 'Front door access, reserved for safety preference & mobility passengers.',
                    avail: 9,
                    total: 12,
                    showBadge: passenger?.safetyPreference == true,
                  ),
                  const SizedBox(height: 12),

                  // General Zone Card
                  _buildZoneDetailCard(
                    zone: 'general',
                    title: 'General Zone (Rows 4-8)',
                    desc: 'Standard seating with gender proximity optimization algorithms.',
                    avail: 18,
                    total: 30,
                    showBadge: false,
                  ),
                  const SizedBox(height: 12),

                  // Standing Limit Zone Card
                  _buildZoneDetailCard(
                    zone: 'standing',
                    title: 'Standing Limit Zone (Rear)',
                    desc: 'Rear standing positions. Warnings trigger at 80% capacity.',
                    avail: 14,
                    total: 18,
                    showBadge: false,
                  ),
                  const SizedBox(height: 24),

                  // Next Departures Section
                  const Text(
                    'Next Scheduled Departures',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDepartureTile('05:00 AM', 'Bus NB-8701 (Express)', 'On Time · Low Crowding'),
                  _buildDepartureTile('09:30 AM', 'Bus NB-8705 (Super Luxury)', 'On Time · Moderate'),
                  _buildDepartureTile('09:00 PM', 'Bus NB-8712 (Night Mail Express)', 'Scheduled'),
                  const SizedBox(height: 32),

                  // Request Seat Button
                  ElevatedButton(
                    onPressed: () => context.go('/stop-select'),
                    child: const Text('Request a seat →'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildZoneDetailCard({
    required String zone,
    required String title,
    required String desc,
    required int avail,
    required int total,
    required bool showBadge,
  }) {
    Color bg = AppColors.getZoneBg(zone);
    Color text = AppColors.getZoneText(zone);
    Color accent = AppColors.getZoneAccent(zone);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ZonePill(zone: zone, small: true),
                  const SizedBox(width: 8),
                  if (showBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Your preference',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              Text(
                '$avail / $total Available',
                style: TextStyle(fontWeight: FontWeight.bold, color: text, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: text),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: TextStyle(fontSize: 11, color: text.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: avail / total,
              minHeight: 6,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureTile(String time, String bus, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: AppColors.primaryNavy),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(bus, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          Text(
            status,
            style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
