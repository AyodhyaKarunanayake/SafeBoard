import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final passenger = authProvider.passenger;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Navy Header with Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 56, bottom: 28),
              color: AppColors.primaryNavy,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    passenger?.name ?? 'Ananya Perera',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    passenger?.email ?? 'ananya.perera@nsbm.ac.lk',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Safety Settings Card
                  const Text(
                    'Safety Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.shield, color: AppColors.priorityAccent, size: 20),
                                SizedBox(width: 10),
                                Text('Priority Zone Preference',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            Switch(
                              value: passenger?.safetyPreference ?? true,
                              activeColor: AppColors.priorityAccent,
                              onChanged: (val) {
                                authProvider.updatePreferences(
                                  safetyPreference: val,
                                  mobilityStatus: passenger?.mobilityStatus ?? 'none',
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Registered Gender',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.generalBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                passenger?.gender.toUpperCase() ?? 'FEMALE',
                                style: const TextStyle(
                                  color: AppColors.generalText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Personal Info Card
                  const Text(
                    'Personal Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Full Name', passenger?.name ?? 'Ananya Perera'),
                        const Divider(height: 16),
                        _buildInfoRow('Email Address', passenger?.email ?? 'ananya.perera@nsbm.ac.lk'),
                        const Divider(height: 16),
                        _buildInfoRow('Phone Number', passenger?.phoneNumber ?? '+94 77 123 4567'),
                        const Divider(height: 16),
                        _buildInfoRow('Mobility Needs', passenger?.mobilityStatus ?? 'None'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Links Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.history, color: AppColors.primaryNavy),
                          title: const Text('Journey History', style: TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/history'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.warning_amber_rounded, color: AppColors.emergencyRed),
                          title: const Text('Incident Log', style: TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/journey'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help_outline, color: AppColors.primaryNavy),
                          title: const Text('Help & Support (1912 Helpline)', style: TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Red Sign Out Button
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        context.go('/welcome');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emergencyRed,
                    ),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
