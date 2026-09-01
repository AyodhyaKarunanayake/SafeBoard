import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/journey_provider.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final journeyProvider = Provider.of<JourneyProvider>(context);
    final passenger = authProvider.passenger;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Deep Navy Header
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 56, bottom: 40),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ayubowan, ${passenger?.name.split(' ').first ?? 'Passenger'} 👋',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Sri Lanka Gender-Aware Transport',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_none, color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Status Chip
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: passenger?.safetyPreference == true
                                  ? AppColors.priorityBg
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: passenger?.safetyPreference == true
                                        ? AppColors.priorityAccent
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  passenger?.safetyPreference == true
                                      ? 'Priority Zone Active'
                                      : 'Standard Allocation',
                                  style: TextStyle(
                                    color: passenger?.safetyPreference == true
                                        ? AppColors.priorityText
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Floating Search Bar Card (Overlaps header by 18px with negative margin)
                Positioned(
                  bottom: -24,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => context.go('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.primaryNavy),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search bus route or destination (e.g. Route 87)',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route 87 Next Bus Departure Hero Card (Always visible for fresh sign-up)
                  Container(
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryNavy.withValues(alpha: 0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryNavy,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Route 87 · Express',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    'On Time · Stand 4',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Next Bus from Pettah (Colombo) ➔ Jaffna',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.access_time_filled, size: 16, color: AppColors.generalAccent),
                            SizedBox(width: 6),
                            Text(
                              'Departs Pettah: 05:00 AM (Bus NB-8701)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Route 87 Real-Time Stop ETA Timeline Preview
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Live Stop ETAs (Pettah to Jaffna):',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildEtaChip('Pettah', '05:00 AM', true),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Ja-Ela', '05:45 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Negombo', '06:15 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Chilaw', '07:15 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Puttalam', '08:30 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Anuradhapura', '10:15 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Vavuniya', '11:45 AM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Kilinochchi', '01:35 PM', false),
                                    _buildEtaArrow(),
                                    _buildEtaChip('Jaffna', '03:30 PM', false),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action Button: Select Stops & Book Seat
                        ElevatedButton.icon(
                          onPressed: () => context.go('/stop-select'),
                          icon: const Icon(Icons.event_seat, size: 18),
                          label: const Text('Allocate Seat & Book Ticket →'),
                        ),
                      ],
                    ),
                  ),

                  // Active Journey Card (Only shown if user has an active booking)
                  if (journeyProvider.isJourneyActive && journeyProvider.currentAllocation != null)
                    GestureDetector(
                      onTap: () => context.go('/journey'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.priorityBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.priorityAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.priorityAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.directions_bus, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'YOUR ACTIVE TRIP · Route 87',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors.priorityText,
                                        ),
                                      ),
                                      ZonePill(zone: 'priority', small: true),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Seat ${journeyProvider.currentAllocation!.seatNumber} · Next: ${journeyProvider.currentStop}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.priorityText),
                          ],
                        ),
                      ),
                    ),

                  // Featured & Recent Routes Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Bus Routes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/search'),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildRouteCard(
                    context,
                    routeNo: '87',
                    name: 'Colombo (Pettah) ➔ Jaffna',
                    type: 'Interprovincial Express (18 Main Stops)',
                  ),
                  const SizedBox(height: 10),
                  _buildRouteCard(
                    context,
                    routeNo: '138',
                    name: 'Pettah ➔ Homagama / NSBM',
                    type: 'High Capacity AC',
                  ),
                  const SizedBox(height: 20),

                  // Non-Intrusive Safety Tip Card (Blue background)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.generalBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.generalAccent.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: AppColors.generalAccent, size: 26),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rule-Based 54-Seat Allocation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.generalText,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Priority seats (Rows 1-3) are near the front door. General seats (Rows 4-10) use gender proximity optimization.',
                                style: TextStyle(fontSize: 11, color: AppColors.generalText),
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
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildEtaChip(String stopName, String etaTime, bool isStart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isStart ? AppColors.primaryNavy : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            stopName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isStart ? Colors.white : AppColors.textDark,
            ),
          ),
          Text(
            etaTime,
            style: TextStyle(
              fontSize: 9,
              color: isStart ? Colors.white70 : AppColors.generalAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textMuted),
    );
  }

  Widget _buildRouteCard(BuildContext context,
      {required String routeNo, required String name, required String type}) {
    return GestureDetector(
      onTap: () => context.go('/route/R_$routeNo'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                routeNo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    type,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
