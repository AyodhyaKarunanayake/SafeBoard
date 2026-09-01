import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final pastTrips = [
    {
      'route': '87',
      'name': 'Colombo (Pettah) → Jaffna',
      'date': 'Today, 05:00 AM',
      'seat': '3A',
      'zone': 'priority',
      'rating': 5,
    },
    {
      'route': '87',
      'name': 'Jaffna → Colombo (Pettah)',
      'date': 'Yesterday, 09:30 AM',
      'seat': '2B',
      'zone': 'priority',
      'rating': 5,
    },
    {
      'route': '138',
      'name': 'Pettah → Homagama / NSBM',
      'date': '18 Jul 2026, 08:30 AM',
      'seat': '4A',
      'zone': 'general',
      'rating': 5,
    },
  ];

  final pastIncidents = [
    {
      'id': 'INC-87-4921',
      'type': 'Unwanted Proximity / Contact',
      'date': 'Today, 06:20 AM',
      'route': 'Route 87',
      'seat': '3A',
      'status': 'Conductor Notified & Resolved',
      'statusColor': Colors.green,
    },
    {
      'id': 'INC-87-1048',
      'type': 'Verbal Harassment',
      'date': '12 Aug 2026, 09:45 AM',
      'route': 'Route 87',
      'seat': '3B',
      'status': 'Escalated to NTC Authority',
      'statusColor': AppColors.emergencyRed,
    },
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel & Safety History'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Past Allocations'),
            Tab(text: 'Safety Incident Log'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Past Allocations
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pastTrips.length,
            itemBuilder: (context, index) {
              final trip = pastTrips[index];
              final String zone = trip['zone'] as String;
              final int rating = trip['rating'] as int;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryNavy,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Route ${trip['route']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Seat ${trip['seat']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                              ZonePill(zone: zone, small: true),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            trip['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trip['date'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                              Row(
                                children: List.generate(5, (sIndex) {
                                  return Icon(
                                    sIndex < rating ? Icons.star : Icons.star_border,
                                    size: 14,
                                    color: AppColors.standingAccent,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Container(
                        height: 4,
                        color: AppColors.getZoneAccent(zone),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Tab 2: Incident Reports Log with Visible Status Badges
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pastIncidents.length,
            itemBuilder: (context, index) {
              final incident = pastIncidents[index];
              final Color statusColor = incident['statusColor'] as Color;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          incident['id'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            incident['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      incident['type'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${incident['route']} · Seat ${incident['seat']} · ${incident['date']}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
