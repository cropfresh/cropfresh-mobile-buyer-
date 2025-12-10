import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// Mobile Entry Screen - Screen 6
/// Phone number input with +91 prefix and validation
class MobileEntryScreen extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String email;
  final String password;

  const MobileEntryScreen({
    super.key,
    required this.businessName,
    required this.businessType,
    required this.email,
    required this.password,
  });

  @override
  State<MobileEntryScreen> createState() => _MobileEntryScreenState();
}

class _MobileEntryScreenState extends State<MobileEntryScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    final phone = _phoneController.text.replaceAll(' ', '');
    setState(() {
      _isValid = phone.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_isValid) return;
    
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    final phoneNumber = '+91${_phoneController.text.replaceAll(' ', '')}';
    
    Navigator.pushNamed(
      context,
      '/otp-verification',
      arguments: {
        'phoneNumber': phoneNumber,
        'registrationData': {
          'businessName': widget.businessName,
          'businessType': widget.businessType,
          'email': widget.email,
          'password': widget.password,
          'mobileNumber': phoneNumber,
        },
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepProgressIndicator(currentStep: 4, totalSteps: 6),
              
              const SizedBox(height: 40),
              
              _buildHeader(),
              
              const SizedBox(height: 40),
              
              _buildPhoneInput(),
              
              const SizedBox(height: 12),
              
              _buildHelperText(),
              
              const Spacer(),
              
              _buildSendOtpButton(),
              
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
            Icons.phone_android_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ).animate(delay: const Duration(milliseconds: 150)).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'We\'ll send an OTP to verify your number',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _phoneFocusNode.hasFocus ? AppColors.primary : AppColors.outline,
          width: _phoneFocusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Country code prefix
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
            ),
            child: Row(
              children: [
                const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '+91',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(width: 1, height: 28, color: AppColors.outline),
          // Phone number input
          Expanded(
            child: TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              keyboardType: TextInputType.phone,
              maxLength: 12,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneNumberFormatter(),
              ],
              decoration: const InputDecoration(
                hintText: '98765 43210',
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onTap: () => setState(() {}),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Clear button
          if (_phoneController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _phoneController.clear();
                setState(() {});
              },
              icon: Icon(Icons.cancel_rounded, color: AppColors.onSurfaceVariant),
            ),
        ],
      ),
    ).animate(delay: const Duration(milliseconds: 300)).fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildHelperText() {
    final phone = _phoneController.text.replaceAll(' ', '');
    
    if (phone.isEmpty) {
      return Text(
        'Enter your 10-digit mobile number',
        style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
        textAlign: TextAlign.center,
      );
    } else if (phone.length < 10) {
      return Text(
        '${10 - phone.length} more digits needed',
        style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
        textAlign: TextAlign.center,
      );
    } else if (!_isValid) {
      return Text(
        'Please enter a valid Indian mobile number',
        style: TextStyle(fontSize: 13, color: AppColors.error),
        textAlign: TextAlign.center,
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
        const SizedBox(width: 6),
        Text(
          'Ready to send OTP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSendOtpButton() {
    return FilledButton(
      onPressed: _isValid && !_isLoading ? _sendOtp : null,
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
                Text('Get OTP'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
    ).animate(delay: const Duration(milliseconds: 500)).fadeIn().slideY(begin: 0.2, end: 0);
  }
}

/// Custom formatter for phone number (XXXXX XXXXX format)
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    
    if (text.length > 10) {
      return oldValue;
    }
    
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(text[i]);
    }
    
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
