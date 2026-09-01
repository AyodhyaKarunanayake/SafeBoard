import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGender = 'female';

  final List<Map<String, String>> _genderOptions = [
    {'value': 'female', 'label': 'Female'},
    {'value': 'male', 'label': 'Male'},
    {'value': 'non-binary', 'label': 'Non-binary'},
    {'value': 'prefer_not_to_say', 'label': 'Prefer not to say'},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Passenger Registration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Join SafeBoard for safer, rule-allocated seating on Sri Lankan public transport.',
              style: TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),

            // Full Name
            const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. Ananya Perera',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'e.g. user@domain.lk',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Minimum 6 characters',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Gender Selector Chips
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _genderOptions.map((opt) {
                final isSelected = _selectedGender == opt['value'];
                return ChoiceChip(
                  label: Text(opt['label']!),
                  selected: isSelected,
                  selectedColor: AppColors.primaryNavy,
                  backgroundColor: AppColors.borderLight.withValues(alpha: 0.5),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedGender = opt['value']!;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Important Note Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.generalBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.generalAccent.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.generalAccent, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your gender informs how our rule-based algorithm allocates your seat safely and respects proximity constraints.',
                      style: TextStyle(fontSize: 12, color: AppColors.generalText),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Continue Button
            ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      if (_nameController.text.trim().isEmpty ||
                          _emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in your name and email address.')),
                        );
                        return;
                      }

                      try {
                        await authProvider.register(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          gender: _selectedGender,
                        );
                      } catch (e) {
                        debugPrint('Registration fallback error: $e');
                      }

                      if (context.mounted) {
                        context.go('/preferences');
                      }
                    },
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Continue to preferences →'),
            ),
          ],
        ),
      ),
    );
  }
}
