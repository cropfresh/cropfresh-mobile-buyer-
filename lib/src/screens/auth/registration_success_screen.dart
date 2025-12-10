import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

/// Registration Success Screen - Screen 9
/// Animated success state with confetti-like celebration
class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  State<RegistrationSuccessScreen> createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              _buildSuccessAnimation(),
              
              const SizedBox(height: 40),
              
              _buildSuccessText(),
              
              const Spacer(flex: 3),
              
              _buildActionButtons(context),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background glow
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.2),
                AppColors.secondary.withValues(alpha: 0),
              ],
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
            )
            .fadeIn(),
        
        // Check circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 60,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
            ),
        
        // Celebration particles
        ..._buildParticles(),
      ],
    );
  }

  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFFFFD54F),
      const Color(0xFF4FC3F7),
    ];
    
    for (int i = 0; i < 12; i++) {
      final dx = 100.0 * (i % 2 == 0 ? 1.2 : 0.8);
      
      particles.add(
        Positioned(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors[i % colors.length],
              shape: i % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: i % 3 != 0 ? BorderRadius.circular(2) : null,
            ),
          )
              .animate(delay: Duration(milliseconds: 200 + (i * 50)))
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              )
              .moveX(
                begin: 0,
                end: dx * (i % 2 == 0 ? 1 : -1) * (i < 6 ? 1 : -1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              )
              .moveY(
                begin: 0,
                end: (i % 3 - 1) * 80.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              )
              .fadeOut(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 300),
              ),
        ),
      );
    }
    
    return particles;
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        Text(
          'Welcome to CropFresh!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 500))
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        Text(
          'Your business account has been created successfully. Start sourcing fresh produce now!',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: const Duration(milliseconds: 600))
            .fadeIn(),
        
        const SizedBox(height: 24),
        
        // Business badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Account Verified',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        )
            .animate(delay: const Duration(milliseconds: 700))
            .fadeIn()
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Start Shopping'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        )
            .animate(delay: const Duration(milliseconds: 800))
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          },
          child: const Text('Complete profile later'),
        )
            .animate(delay: const Duration(milliseconds: 900))
            .fadeIn(),
      ],
    );
  }
}
