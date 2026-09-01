import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/journey_provider.dart';
import '../../constants/colors.dart';

class RequestingScreen extends StatefulWidget {
  const RequestingScreen({super.key});

  @override
  State<RequestingScreen> createState() => _RequestingScreenState();
}

class _RequestingScreenState extends State<RequestingScreen> {
  int _currentStep = 0;
  bool _isComplete = false;

  final List<String> _steps = [
    'Checking zone availability',
    'Applying safety rules & preferences',
    'Optimising passenger proximity',
    'Seat confirmed ✓',
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final journeyProvider = Provider.of<JourneyProvider>(context, listen: false);

    // Step-by-step timer animation
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentStep < _steps.length - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isComplete = true;
        });
      }
    });

    // Trigger Cloud Function / Algorithm allocation
    final alloc = await bookingProvider.requestAllocation(authProvider.passenger!);
    journeyProvider.setCurrentAllocation(alloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Pink Shield Icon Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.priorityBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield,
                  size: 64,
                  color: AppColors.priorityAccent,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Finding Your Seat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our rule-based engine is applying 3-zone safety and proximity rules...',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Four Animated Step Rows
              Column(
                children: List.generate(_steps.length, (index) {
                  final bool isDone = index <= _currentStep;
                  final bool isCurrent = index == _currentStep && !_isComplete;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDone ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDone ? AppColors.priorityAccent.withValues(alpha: 0.4) : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isDone)
                          const Icon(Icons.check_circle, color: AppColors.priorityAccent, size: 20)
                        else if (isCurrent)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryNavy,
                            ),
                          )
                        else
                          const Icon(Icons.radio_button_unchecked, color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            _steps[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                              color: isDone ? AppColors.textDark : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const Spacer(),

              // "See my seat →" button appears after 2.5s completion
              if (_isComplete)
                ElevatedButton(
                  onPressed: () {
                    context.go('/allocation');
                  },
                  child: const Text('See my seat →'),
                )
              else
                const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
