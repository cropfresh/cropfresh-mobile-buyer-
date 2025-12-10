import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// OTP Verification Screen - Screen 7
/// 6-digit OTP entry with auto-submit and resend timer
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic> registrationData;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.registrationData,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length != 6) return;
    
    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // For demo, accept any 6-digit OTP
    // In production, verify with backend
    if (otp == '123456' || otp.length == 6) {
      Navigator.pushNamed(
        context,
        '/location-setup',
        arguments: {'registrationData': widget.registrationData},
      );
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      HapticFeedback.heavyImpact();
      _otpController.clear();
    }
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;
    
    HapticFeedback.selectionClick();
    
    // Simulate resend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP resent successfully'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    
    _startResendTimer();
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
              const StepProgressIndicator(currentStep: 5, totalSteps: 6),
              
              const SizedBox(height: 40),
              
              _buildHeader(),
              
              const SizedBox(height: 48),
              
              _buildOtpInput(),
              
              const SizedBox(height: 24),
              
              _buildResendSection(),
              
              const Spacer(),
              
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              
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
            Icons.sms_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ).animate(delay: const Duration(milliseconds: 150)).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Enter the 6-digit code sent to',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
        
        const SizedBox(height: 4),
        
        Text(
          widget.phoneNumber,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ).animate(delay: const Duration(milliseconds: 300)).fadeIn(),
      ],
    );
  }

  Widget _buildOtpInput() {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: _otpController,
      autoFocus: true,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 200),
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 56,
        fieldWidth: 48,
        activeFillColor: AppColors.surfaceContainer,
        inactiveFillColor: AppColors.surfaceContainer,
        selectedFillColor: AppColors.surfaceContainer,
        activeColor: _isError ? AppColors.error : AppColors.primary,
        inactiveColor: AppColors.outline,
        selectedColor: AppColors.primary,
        errorBorderColor: AppColors.error,
      ),
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _isError ? AppColors.error : AppColors.onSurface,
      ),
      onCompleted: _verifyOtp,
      onChanged: (value) {
        if (_isError) {
          setState(() => _isError = false);
        }
      },
    ).animate(delay: const Duration(milliseconds: 350)).fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        if (_isError)
          Text(
            'Invalid OTP. Please try again.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ).animate().shake(),
        
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code? ",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: _resendSeconds == 0 ? _resendOtp : null,
              child: Text(
                _resendSeconds > 0 
                    ? 'Resend in ${_resendSeconds}s'
                    : 'Resend OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _resendSeconds > 0 
                      ? AppColors.onSurfaceVariant 
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate(delay: const Duration(milliseconds: 400)).fadeIn();
  }
}
