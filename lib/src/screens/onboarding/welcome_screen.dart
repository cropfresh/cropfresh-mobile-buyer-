import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

/// Welcome Screen - Screen 2
/// Shows benefits and Login/Register options
/// Follows "Efficiency First" UX direction
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Hero Section
              _buildHeroSection(),
              
              const SizedBox(height: 48),
              
              // Benefits List
              _buildBenefitsList(),
              
              const Spacer(flex: 2),
              
              // Action Buttons
              _buildActionButtons(context),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.shopping_cart_rounded,
            size: 50,
            color: AppColors.primary,
          ),
        )
            .animate()
            .scale(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
            )
            .fadeIn(),
        
        const SizedBox(height: 24),
        
        Text(
          'Source Fresh Produce',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Direct from farms to your business',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 300))
            .fadeIn(),
      ],
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {'icon': Icons.verified_rounded, 'text': 'Quality guaranteed produce'},
      {'icon': Icons.trending_down_rounded, 'text': 'Best wholesale prices'},
      {'icon': Icons.local_shipping_rounded, 'text': 'Fast delivery to your location'},
      {'icon': Icons.support_agent_rounded, 'text': '24/7 business support'},
    ];

    return Column(
      children: benefits.asMap().entries.map((entry) {
        final index = entry.key;
        final benefit = entry.value;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                benefit['text'] as String,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 400 + (index * 100)))
            .fadeIn()
            .slideX(begin: -0.1, end: 0);
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Register Button (Primary)
        FilledButton(
          onPressed: () => Navigator.pushNamed(context, '/business-info'),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Business Account'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        )
            .animate(delay: const Duration(milliseconds: 600))
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        // Login Button (Secondary)
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: const Text('Already have an account? Login'),
        )
            .animate(delay: const Duration(milliseconds: 700))
            .fadeIn(),
        
        const SizedBox(height: 16),
        
        // Terms text
        Text(
          'By continuing, you agree to our Terms of Service',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 800))
            .fadeIn(),
      ],
    );
  }
}
