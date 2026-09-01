import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../widgets/zone_pill.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _stars = 5;
  final List<String> _tags = [
    'Felt safe',
    'Seat well allocated',
    'Conductor helpful',
    'Clear QR process',
    'No issues',
  ];
  final Set<String> _selectedTags = {'Felt safe', 'Seat well allocated'};
  final _commentsController = TextEditingController();

  String get _safetyLabel {
    switch (_stars) {
      case 1:
        return 'Not safe';
      case 2:
        return 'Uncomfortable';
      case 3:
        return 'Acceptable';
      case 4:
        return 'Good';
      case 5:
        return 'Very safe';
      default:
        return 'Very safe';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Route 138 Complete',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pettah → NSBM Green University Campus',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            const ZonePill(zone: 'priority', small: true),
            const SizedBox(height: 28),

            // 5-Star Tappable Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int starVal = index + 1;
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    starVal <= _stars ? Icons.star : Icons.star_border,
                    color: AppColors.standingAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _stars = starVal;
                    });
                  },
                );
              }),
            ),
            Text(
              _safetyLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 28),

            // Feedback Tag Chips
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What made your journey safe?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                bool isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: AppColors.primaryNavy,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Optional Textarea
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Comments',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Help us improve the allocation rules and bus safety...',
              ),
            ),
            const SizedBox(height: 32),

            // Submit Rating & Skip Buttons
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you! Feedback logged to analytics.')),
                );
                context.go('/home');
              },
              child: const Text('Submit rating'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
