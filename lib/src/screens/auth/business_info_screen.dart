import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// Business Info Screen - Screen 3
/// First step of registration: Enter business name
class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _businessNameController.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _isValid = _businessNameController.text.trim().length >= 3;
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _continueToNextStep() {
    if (!_isValid) return;
    
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(
      context,
      '/business-type',
      arguments: {'businessName': _businessNameController.text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              const StepProgressIndicator(currentStep: 1, totalSteps: 6),
              
              const SizedBox(height: 40),
              
              // Header
              _buildHeader(),
              
              const SizedBox(height: 40),
              
              // Business Name Input
              _buildBusinessNameInput(),
              
              const SizedBox(height: 12),
              
              // Helper text
              Text(
                'Enter your registered business or shop name',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: const Duration(milliseconds: 400)).fadeIn(),
              
              const Spacer(),
              
              // Continue Button
              _buildContinueButton(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.business_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        )
            .animate()
            .scale(curve: Curves.easeOutBack)
            .fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          'Business Name',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        )
            .animate(delay: const Duration(milliseconds: 150))
            .fadeIn()
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'What\'s your business called?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
      ],
    );
  }

  Widget _buildBusinessNameInput() {
    return TextField(
      controller: _businessNameController,
      focusNode: _focusNode,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: 'e.g., Fresh Mart Groceries',
        prefixIcon: Icon(
          Icons.store_rounded,
          color: _focusNode.hasFocus ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
        suffixIcon: _isValid
            ? Icon(Icons.check_circle_rounded, color: AppColors.secondary)
            : null,
      ),
      onSubmitted: (_) => _continueToNextStep(),
    ).animate(delay: const Duration(milliseconds: 300)).fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildContinueButton() {
    return FilledButton(
      onPressed: _isValid ? _continueToNextStep : null,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Continue'),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    ).animate(delay: const Duration(milliseconds: 500)).fadeIn().slideY(begin: 0.2, end: 0);
  }
}
