import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

/// Reset Password Screen - AC9: Password Reset Flow
/// Accessed via deep link from email
class ResetPasswordScreen extends StatefulWidget {
  final String token;
  
  const ResetPasswordScreen({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;
  
  // Password validation states
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
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
    return _hasMinLength && 
           _hasUppercase && 
           _hasNumber && 
           _hasSpecialChar && 
           _passwordsMatch;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_isFormValid) return;
    
    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Call API - POST /v1/auth/buyer/reset-password
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSuccess = true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Reset link has expired. Please request a new one.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !_isSuccess ? AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _isSuccess ? _buildSuccessContent() : _buildFormContent(),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        
        _buildHeader(),
        
        const SizedBox(height: 40),
        
        if (_errorMessage != null) ...[
          _buildErrorBanner(),
          const SizedBox(height: 20),
        ],
        
        _buildPasswordInput(),
        
        const SizedBox(height: 16),
        
        _buildPasswordStrength(),
        
        const SizedBox(height: 24),
        
        _buildConfirmPasswordInput(),
        
        const SizedBox(height: 40),
        
        _buildResetButton(),
        
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.password_rounded,
            size: 40,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 24),
        
        Text(
          'Create New Password',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Your new password must be different from previously used passwords.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 250.ms).fadeIn(),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: AppColors.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/forgot-password'),
                  child: Text(
                    'Request new reset link →',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().shake(hz: 2, duration: 400.ms);
  }

  Widget _buildPasswordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'New Password',
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
    ).animate(delay: 300.ms).fadeIn();
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
    ).animate(delay: 350.ms).fadeIn();
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
        labelText: 'Confirm New Password',
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
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _buildResetButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      child: FilledButton(
        onPressed: _isFormValid && !_isLoading ? _handleResetPassword : null,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Reset Password', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
        
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 48,
            color: Colors.white,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 40),
        
        Text(
          'Password Updated!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        Text(
          'Your password has been updated successfully. You can now sign in with your new password.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 300.ms).fadeIn(),
        
        const SizedBox(height: 48),
        
        FilledButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue to Login', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 32),
      ],
    );
  }
}
