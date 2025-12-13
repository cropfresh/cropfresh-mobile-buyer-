import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../models/team_member.dart';
import '../../widgets/team_widgets.dart';

/// Accept Team Invitation Screen (AC4)
/// Simplified registration for invited users (pre-filled business/role)
class AcceptInvitationScreen extends StatefulWidget {
  final String invitationToken;
  final String? businessName;
  final String? email;
  final BuyerRole? role;

  const AcceptInvitationScreen({
    super.key,
    required this.invitationToken,
    this.businessName,
    this.email,
    this.role,
  });

  @override
  State<AcceptInvitationScreen> createState() => _AcceptInvitationScreenState();
}

class _AcceptInvitationScreenState extends State<AcceptInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingInvitation = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Invitation data (pre-filled from token)
  String? _businessName;
  String? _email;
  BuyerRole? _role;
  bool _invitationValid = true;
  String? _invitationError;

  // Password strength
  int _passwordStrength = 0;
  List<String> _passwordIssues = [];

  @override
  void initState() {
    super.initState();
    _loadInvitationDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadInvitationDetails() async {
    setState(() => _isLoadingInvitation = true);
    
    try {
      // TODO: Call API to validate token and get invitation details
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - in real app, this comes from API
      setState(() {
        _businessName = widget.businessName ?? 'Fresh Kitchen Restaurant';
        _email = widget.email ?? 'john@freshkitchen.com';
        _role = widget.role ?? BuyerRole.procurementManager;
        _invitationValid = true;
        _isLoadingInvitation = false;
      });
    } catch (e) {
      setState(() {
        _invitationValid = false;
        _invitationError = 'This invitation has expired or is invalid.';
        _isLoadingInvitation = false;
      });
    }
  }

  void _checkPasswordStrength(String password) {
    int strength = 0;
    List<String> issues = [];

    if (password.length >= 8) {
      strength++;
    } else {
      issues.add('At least 8 characters');
    }

    if (password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    } else {
      issues.add('One uppercase letter');
    }

    if (password.contains(RegExp(r'[a-z]'))) {
      strength++;
    } else {
      issues.add('One lowercase letter');
    }

    if (password.contains(RegExp(r'[0-9]'))) {
      strength++;
    } else {
      issues.add('One number');
    }

    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength++;
    } else {
      issues.add('One special character');
    }

    setState(() {
      _passwordStrength = strength;
      _passwordIssues = issues;
    });
  }

  Color get _strengthColor {
    if (_passwordStrength <= 2) return AppColors.error;
    if (_passwordStrength <= 3) return AppColors.warning;
    return AppColors.success;
  }

  String get _strengthLabel {
    if (_passwordStrength <= 2) return 'Weak';
    if (_passwordStrength <= 3) return 'Fair';
    if (_passwordStrength <= 4) return 'Good';
    return 'Strong';
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (_passwordStrength < 4) {
      return 'Password must meet all requirements';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Call API to accept invitation
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        _showWelcomeDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete registration: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.celebration,
            color: AppColors.success,
            size: 48,
          ),
        ),
        title: Text('Welcome to $_businessName!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your account has been created successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RoleColors.getBackgroundColor(_role!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.badge_outlined,
                    color: RoleColors.getForegroundColor(_role!),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your role: ${_role!.displayName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: RoleColors.getForegroundColor(_role!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to dashboard with JWT token
            },
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingInvitation) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Validating invitation...',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_invitationValid) {
      return _buildExpiredScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Registration'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Welcome Header
            _buildWelcomeHeader().animate().fadeIn(duration: 200.ms),
            const SizedBox(height: 32),
            
            // Pre-filled Info (Read-only)
            _buildPrefilledInfo().animate().fadeIn(duration: 200.ms, delay: 50.ms),
            const SizedBox(height: 24),
            
            // Full Name
            _buildNameField().animate().fadeIn(duration: 200.ms, delay: 100.ms),
            const SizedBox(height: 16),
            
            // Password
            _buildPasswordField().animate().fadeIn(duration: 200.ms, delay: 150.ms),
            const SizedBox(height: 8),
            
            // Password Strength
            _buildPasswordStrength().animate().fadeIn(duration: 200.ms, delay: 175.ms),
            const SizedBox(height: 16),
            
            // Confirm Password
            _buildConfirmPasswordField().animate().fadeIn(duration: 200.ms, delay: 200.ms),
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton().animate().fadeIn(duration: 200.ms, delay: 250.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredScreen() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.link_off,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Invitation Expired',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _invitationError ?? 'This invitation link has expired or is invalid.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please contact your organization admin to request a new invitation.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.waving_hand,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to CropFresh!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete your registration to join $_businessName',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPrefilledInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.business,
            label: 'Organization',
            value: _businessName ?? '',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _email ?? '',
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.badge_outlined, size: 20, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 12),
              Text(
                'Role',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (_role != null) RoleBadge(role: _role!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Full Name', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: _validateName,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Password', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          onChanged: _checkPasswordStrength,
          validator: _validatePassword,
        ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    if (_passwordController.text.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _passwordStrength / 5,
                  backgroundColor: AppColors.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _strengthLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _strengthColor,
              ),
            ),
          ],
        ),
        if (_passwordIssues.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _passwordIssues.map((issue) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  issue,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.error,
                  ),
                ),
              ],
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Confirm Password', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Re-enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
          validator: _validateConfirmPassword,
          onFieldSubmitted: (_) => _onSubmit(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _onSubmit,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline),
                SizedBox(width: 8),
                Text('Complete Registration'),
              ],
            ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }
}
