import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../services/buyer_auth_service.dart';

/// Forgot Password Screen - AC9: Forgot Password Flow
/// Premium, clean design following Buyers App UX patterns
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!_isEmailValid) return;
    
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final result = await BuyerAuthService.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isEmailSent = result.success;
    });
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
          child: _isEmailSent ? _buildSuccessContent() : _buildFormContent(),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        
        _buildHeader(),
        
        const SizedBox(height: 40),
        
        _buildEmailInput(),
        
        const SizedBox(height: 32),
        
        _buildSendButton(),
        
        const SizedBox(height: 24),
        
        _buildBackToLogin(),
        
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
            Icons.lock_reset_rounded,
            size: 40,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 24),
        
        Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
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

  Widget _buildEmailInput() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _handleSendResetLink(),
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'you@business.com',
        prefixIcon: Icon(Icons.email_outlined, color: AppColors.onSurfaceVariant),
        suffixIcon: _isEmailValid
            ? Icon(Icons.check_circle_rounded, color: AppColors.secondary)
            : null,
      ),
    ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildSendButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      child: FilledButton(
        onPressed: _isEmailValid && !_isLoading ? _handleSendResetLink : null,
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
                  Icon(Icons.send_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Send Reset Link', style: TextStyle(fontSize: 16)),
                ],
              ),
      ),
    ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildBackToLogin() {
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: const Text('Back to Login'),
      ),
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 80),
        
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: 48,
            color: AppColors.secondary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 32),
        
        Text(
          'Check Your Email',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 16),
        
        Text(
          'We\'ve sent a password reset link to',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 250.ms).fadeIn(),
        
        const SizedBox(height: 4),
        
        Text(
          _emailController.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 300.ms).fadeIn(),
        
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'The link expires in 1 hour. Check your spam folder if you don\'t see it.',
                  style: TextStyle(
                    color: AppColors.info,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ).animate(delay: 350.ms).fadeIn(),
        
        const SizedBox(height: 40),
        
        OutlinedButton(
          onPressed: () => Navigator.popUntil(context, (route) => route.settings.name == '/login' || route.isFirst),
          child: const Text('Back to Login'),
        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 16),
        
        Center(
          child: TextButton(
            onPressed: () {
              setState(() => _isEmailSent = false);
            },
            child: Text(
              'Didn\'t receive email? Try again',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
        ).animate(delay: 450.ms).fadeIn(),
        
        const SizedBox(height: 32),
      ],
    );
  }
}
