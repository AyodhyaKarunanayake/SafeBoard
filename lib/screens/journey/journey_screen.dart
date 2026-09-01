import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/journey_provider.dart';
import '../../providers/booking_provider.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';
import '../../widgets/occupancy_bar.dart';
import '../../widgets/sos_button.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journeyProvider = Provider.of<JourneyProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    final alloc = journeyProvider.currentAllocation;
    final seatNo = alloc?.seatNumber ?? '3A';

    final route = bookingProvider.selectedRoute ?? bookingProvider.sampleRoutes.first;
    final stops = route.stops;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Deep Navy Header + Occupancy Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 44, bottom: 12),
                color: AppColors.primaryNavy,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => context.go('/home'),
                            ),
                            Text(
                              'Seat $seatNo · Priority Zone',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!journeyProvider.isTrippingMode)
                              ElevatedButton.icon(
                                onPressed: () {
                                  journeyProvider.activateTrippingMode();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Conductor Scanned QR! Switched to Live Tripping Mode.')),
                                  );
                                },
                                icon: const Icon(Icons.qr_code_scanner, size: 14),
                                label: const Text('Scan QR (Board)', style: TextStyle(fontSize: 10)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: const Size(60, 30),
                                ),
                              ),
                            const SizedBox(width: 6),
                            const ZonePill(zone: 'priority', small: true),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Occupancy Card (Dark Overlay on Navy)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: OccupancyBar(
                        percentage: journeyProvider.currentOccupancy / 56.0,
                        priorityCount: journeyProvider.priorityOccupied,
                        generalCount: journeyProvider.generalOccupied,
                        standingCount: journeyProvider.standingCount,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // TabBar for Stop Progress vs Live Map
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: const [
                        Tab(text: 'Stop Progress'),
                        Tab(text: 'Live Bus Map'),
                      ],
                    ),
                  ],
                ),
              ),

              // IN-APP ARRIVAL / TRIP ALERTS BANNER
              if (journeyProvider.isApproachingAlighting)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.amber.shade900,
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Approaching ${alloc?.alightingStop ?? 'Jaffna Central'} in 5 mins! Please prepare to alight.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          journeyProvider.completeJourney();
                        },
                        child: const Text('ALIGHT NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                      ),
                    ],
                  ),
                ),

              // JOURNEY COMPLETED GREETING BANNER
              if (journeyProvider.isJourneyCompleted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  color: Colors.green.shade800,
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎉 Journey Completed!',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Thank you for traveling safely with SafeBoard on Route 87.',
                              style: TextStyle(color: Colors.white70, fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.go('/rating'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green.shade900,
                          minimumSize: const Size(60, 32),
                        ),
                        child: const Text('Rate Trip', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              // PERSISTENT RED EMERGENCY BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: AppColors.emergencyRed,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency reporting active',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Conductor notified instantly · Seat logged',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/incident?type=physical_assault&severity=high');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.emergencyRed,
                        minimumSize: const Size(54, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'SOS',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Live Stop Progress
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live Stop Progress (Route 87)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 14),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: stops.length,
                            itemBuilder: (context, index) {
                              final stop = stops[index];
                              bool isPast = index < 3;
                              bool isCurrent = index == 3;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: isPast
                                              ? Colors.green
                                              : isCurrent
                                                  ? AppColors.primaryNavy
                                                  : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isPast
                                                ? Colors.green
                                                : isCurrent
                                                    ? AppColors.primaryNavy
                                                    : AppColors.borderLight,
                                            width: 2,
                                          ),
                                        ),
                                        child: isPast
                                            ? const Icon(Icons.check, size: 12, color: Colors.white)
                                            : isCurrent
                                                ? const Center(
                                                    child: CircleAvatar(
                                                      radius: 3,
                                                      backgroundColor: Colors.white,
                                                    ),
                                                  )
                                                : null,
                                      ),
                                      if (index < stops.length - 1)
                                        Container(
                                          width: 2,
                                          height: 32,
                                          color: isPast ? Colors.green : AppColors.borderLight,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            stop,
                                            style: TextStyle(
                                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                              fontSize: 12,
                                              color: isCurrent ? AppColors.primaryNavy : AppColors.textDark,
                                            ),
                                          ),
                                          if (isCurrent)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryNavy,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'CURRENT',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: () => context.go('/incident'),
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
                            label: const Text('Report a safety incident'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emergencyRed,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              journeyProvider.endJourney();
                              context.go('/rating');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryNavy,
                              side: const BorderSide(color: AppColors.primaryNavy),
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('End journey and rate'),
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Live Bus Map View (Stretch Feature)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live Bus GPS Map (Route 87)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Real-time GPS tracking for Bus NB-8701 on Colombo - Jaffna Route 87.',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 16),

                          // Visual Map Box Graphic
                          Container(
                            height: 260,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.shade300, width: 1.5),
                            ),
                            child: Stack(
                              children: [
                                // Map Grid Lines Graphic
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: CustomPaint(
                                      painter: GridMapPainter(),
                                    ),
                                  ),
                                ),

                                // Bus Pin Overlay at Current Stop (Anuradhapura)
                                const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.directions_bus_filled, color: AppColors.primaryNavy, size: 36),
                                      SizedBox(height: 4),
                                      Card(
                                        color: AppColors.primaryNavy,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Text(
                                            'Bus NB-8701 · Anuradhapura',
                                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // FLOATING SOS BUTTON (ALWAYS VISIBLE ABOVE ALL SCROLLABLE CONTENT)
          Positioned(
            bottom: 20,
            right: 16,
            child: SOSButton(
              onPressed: () {
                context.go('/incident?type=physical_assault&severity=high');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade800
      ..strokeWidth = 1.0;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
