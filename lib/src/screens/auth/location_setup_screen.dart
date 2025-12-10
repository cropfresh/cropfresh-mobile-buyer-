import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// Location Setup Screen - Screen 8
/// GPS location or manual address entry
class LocationSetupScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const LocationSetupScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLocating = false;

  bool get _isFormValid {
    return _addressController.text.trim().length >= 10 &&
           _cityController.text.trim().length >= 2 &&
           _stateController.text.trim().length >= 2 &&
           _pincodeController.text.trim().length == 6;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    HapticFeedback.selectionClick();
    setState(() => _isLocating = true);
    
    // Simulate location detection
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    setState(() {
      _isLocating = false;
      _addressController.text = 'Commercial Street, Near Main Market';
      _cityController.text = 'Bangalore';
      _stateController.text = 'Karnataka';
      _pincodeController.text = '560001';
    });
  }

  Future<void> _completeRegistration() async {
    if (!_isFormValid) return;
    
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    // Simulate API call to complete registration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    
    setState(() => _isLoading = false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/registration-success',
      (route) => false,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const StepProgressIndicator(currentStep: 6, totalSteps: 6),
                    
                    const SizedBox(height: 32),
                    
                    _buildHeader(),
                    
                    const SizedBox(height: 32),
                    
                    _buildLocationButton(),
                    
                    const SizedBox(height: 24),
                    
                    _buildDivider(),
                    
                    const SizedBox(height: 24),
                    
                    _buildAddressForm(),
                    
                    const SizedBox(height: 24),
                    
                    _buildGstInput(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            _buildCompleteButton(),
          ],
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
            Icons.location_on_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          'Business Location',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ).animate(delay: const Duration(milliseconds: 150)).fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Where is your business located?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: const Duration(milliseconds: 250)).fadeIn(),
      ],
    );
  }

  Widget _buildLocationButton() {
    return OutlinedButton(
      onPressed: _isLocating ? null : _detectLocation,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLocating
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Detecting location...'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.my_location_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Use Current Location', style: TextStyle(color: AppColors.primary)),
              ],
            ),
    ).animate(delay: const Duration(milliseconds: 300)).fadeIn();
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or enter manually',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outline)),
      ],
    );
  }

  Widget _buildAddressForm() {
    return Column(
      children: [
        TextField(
          controller: _addressController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Street Address *',
            hintText: 'Shop No, Building, Street',
          ),
          onChanged: (_) => setState(() {}),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'City *',
                  hintText: 'City',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _stateController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'State *',
                  hintText: 'State',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        TextField(
          controller: _pincodeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Pincode *',
            hintText: '560001',
            counterText: '',
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    ).animate(delay: const Duration(milliseconds: 350)).fadeIn();
  }

  Widget _buildGstInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GST Number (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _gstController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 15,
          decoration: InputDecoration(
            hintText: '22AAAAA0000A1Z5',
            counterText: '',
            helperText: 'Add later for tax invoices',
            helperStyle: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    ).animate(delay: const Duration(milliseconds: 400)).fadeIn();
  }

  Widget _buildCompleteButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: FilledButton(
        onPressed: _isFormValid && !_isLoading ? _completeRegistration : null,
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
                  Text('Complete Registration'),
                  SizedBox(width: 8),
                  Icon(Icons.check_rounded, size: 20),
                ],
              ),
      ),
    );
  }
}
