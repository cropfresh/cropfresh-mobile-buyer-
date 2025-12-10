import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// Credentials Screen - Screen 5
/// Email and Password entry with real-time validation
class CredentialsScreen extends StatefulWidget {
  final String businessName;
  final String businessType;

  const CredentialsScreen({
    super.key,
    required this.businessName,
    required this.businessType,
  });

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Validation states
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _passwordsMatch = password.isNotEmpty && password == confirmPassword;
    });
  }

  bool get _isFormValid {
    return _isEmailValid && 
           _hasMinLength && 
           _hasUppercase && 
           _hasNumber && 
           _hasSpecialChar && 
           _passwordsMatch;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continueToNextStep() {
    if (!_isFormValid) return;
    
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(
      context,
      '/mobile-entry',
      arguments: {
        'businessName': widget.businessName,
        'businessType': widget.businessType,
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      },
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepProgressIndicator(currentStep: 3, totalSteps: 6),
              
              const SizedBox(height: 32),
              
              _buildHeader(),
              
              const SizedBox(height: 32),
              
              // Email Input
              _buildEmailInput(),
              
              const SizedBox(height: 20),
              
              // Password Input
              _buildPasswordInput(),
              
              const SizedBox(height: 16),
              
              // Password Strength Indicators
              _buildPasswordStrength(),
              
              const SizedBox(height: 20),
              
              // Confirm Password
              _buildConfirmPasswordInput(),
              
              const SizedBox(height: 40),
              
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
            Icons.lock_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          'Create Login',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ).animate(delay: const Duration(milliseconds: 150)).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Set up email and password for your account',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
      ],
    );
  }

  Widget _buildEmailInput() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'you@business.com',
        prefixIcon: Icon(Icons.email_outlined, color: AppColors.onSurfaceVariant),
        suffixIcon: _isEmailValid
            ? Icon(Icons.check_circle_rounded, color: AppColors.secondary)
            : null,
      ),
    ).animate(delay: const Duration(milliseconds: 300)).fadeIn();
  }

  Widget _buildPasswordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Create a strong password',
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    ).animate(delay: const Duration(milliseconds: 350)).fadeIn();
  }

  Widget _buildPasswordStrength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirementRow('At least 8 characters', _hasMinLength),
        _buildRequirementRow('One uppercase letter', _hasUppercase),
        _buildRequirementRow('One number', _hasNumber),
        _buildRequirementRow('One special character (!@#\$%^&*)', _hasSpecialChar),
      ],
    ).animate(delay: const Duration(milliseconds: 400)).fadeIn();
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isMet ? AppColors.secondary : Colors.transparent,
              border: Border.all(
                color: isMet ? AppColors.secondary : AppColors.outline,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isMet
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? AppColors.secondary : AppColors.onSurfaceVariant,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordInput() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_passwordsMatch && _confirmPasswordController.text.isNotEmpty)
              Icon(Icons.check_circle_rounded, color: AppColors.secondary),
            IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.onSurfaceVariant,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ],
        ),
        errorText: _confirmPasswordController.text.isNotEmpty && !_passwordsMatch
            ? 'Passwords do not match'
            : null,
      ),
    ).animate(delay: const Duration(milliseconds: 450)).fadeIn();
  }

  Widget _buildContinueButton() {
    return FilledButton(
      onPressed: _isFormValid ? _continueToNextStep : null,
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
