import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import 'widgets/section_card.dart';

/// Buyer Profile Screen - Story 2.7 (AC2)
/// Complete profile management for buyers with delivery addresses
class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  bool _isEditing = false;
  bool _hasChanges = false;
  bool _isSaving = false;

  // User data
  String _businessName = 'Fresh Mart Groceries';
  String _businessAddress = '123, MG Road, Koramangala, Bangalore 560034';
  String _contactEmail = 'orders@freshmart.in';
  String _qualityPreference = 'Grade A only';
  String _orderFrequency = 'Weekly';
  
  // Delivery addresses
  List<DeliveryAddress> _addresses = [
    DeliveryAddress(
      id: '1',
      label: 'Main Warehouse',
      addressLine1: '45, Industrial Area',
      city: 'Bangalore',
      pincode: '560068',
      instructions: 'Use back gate for trucks',
      isDefault: true,
    ),
    DeliveryAddress(
      id: '2',
      label: 'Store #2',
      addressLine1: '78, Brigade Road',
      city: 'Bangalore',
      pincode: '560025',
      instructions: '',
      isDefault: false,
    ),
  ];

  final List<String> _qualityOptions = ['Grade A only', 'Grade A & B', 'All grades'];
  final List<String> _frequencyOptions = ['Daily', 'Weekly', 'Monthly'];

  void _toggleEdit() {
    HapticFeedback.lightImpact();
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _hasChanges = false;
    });
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _saveChanges() async {
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isSaving = false;
      _isEditing = false;
      _hasChanges = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Profile updated successfully'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: _toggleEdit,
            icon: Icon(
              _isEditing ? Icons.close_rounded : Icons.edit_rounded,
              size: 20,
            ),
            label: Text(_isEditing ? 'Cancel' : 'Edit'),
            style: TextButton.styleFrom(
              foregroundColor: _isEditing ? AppColors.error : AppColors.primary,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Business Information
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Business Information',
              icon: Icons.storefront_rounded,
              children: [
                _buildField('Business Name', _businessName, Icons.business_rounded),
                _buildTextArea('Business Address', _businessAddress, Icons.location_on_rounded),
                _buildField('Contact Email', _contactEmail, Icons.email_rounded, 
                    hint: 'Requires email verification on change'),
              ],
            ),
          ),

          // Preferences
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Order Preferences',
              icon: Icons.tune_rounded,
              children: [
                _buildDropdown('Quality Preference', _qualityPreference, _qualityOptions, (v) {
                  setState(() => _qualityPreference = v);
                  _markChanged();
                }),
                _buildDropdown('Order Frequency', _orderFrequency, _frequencyOptions, (v) {
                  setState(() => _orderFrequency = v);
                  _markChanged();
                }),
              ],
            ),
          ),

          // Delivery Addresses
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Delivery Addresses',
              icon: Icons.local_shipping_rounded,
              trailing: IconButton(
                onPressed: () => _showAddAddressModal(),
                icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                tooltip: 'Add Address',
              ),
              children: [
                if (_addresses.isEmpty)
                  _buildEmptyAddresses()
                else
                  ..._addresses.map((addr) => _buildAddressCard(addr)),
              ],
            ),
          ),

          // Change History Link
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/profile/history'),
                icon: Icon(Icons.history_rounded),
                label: Text('View Change History'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _hasChanges ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _hasChanges ? 1.0 : 0.0,
          child: FloatingActionButton.extended(
            onPressed: _isSaving ? null : _saveChanges,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: _isSaving
                ? SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(Icons.check_rounded),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, IconData icon, {String? hint}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: TextEditingController(text: value),
                          decoration: InputDecoration.collapsed(hintText: 'Enter $label'),
                          onChanged: (_) => _markChanged(),
                        )
                      : Text(value, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(hint, style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              )),
            ),
        ],
      ),
    );
  }

  Widget _buildTextArea(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: TextEditingController(text: value),
                          maxLines: 3,
                          decoration: InputDecoration.collapsed(hintText: 'Enter $label'),
                          onChanged: (_) => _markChanged(),
                        )
                      : Text(value, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String> onChanged) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500,
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: _isEditing ? (v) => onChanged(v!) : null,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.onSurfaceVariant),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(DeliveryAddress address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: address.isDefault ? AppColors.primaryContainer.withValues(alpha: 0.3) : AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(12),
        border: address.isDefault ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(address.label, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Default', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) => _handleAddressAction(v, address),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'default', child: Text('Set as Default')),
                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(address.addressLine1),
          Text('${address.city} - ${address.pincode}'),
          if (address.instructions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(address.instructions, style: TextStyle(
              color: AppColors.onSurfaceVariant, fontSize: 13, fontStyle: FontStyle.italic,
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyAddresses() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.location_off_rounded, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text('No delivery addresses', style: TextStyle(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showAddAddressModal(),
            icon: Icon(Icons.add_rounded),
            label: Text('Add Address'),
          ),
        ],
      ),
    );
  }

  void _handleAddressAction(String action, DeliveryAddress address) {
    switch (action) {
      case 'edit':
        _showAddAddressModal(address: address);
        break;
      case 'default':
        setState(() {
          for (var a in _addresses) {
            a.isDefault = a.id == address.id;
          }
        });
        break;
      case 'delete':
        setState(() => _addresses.removeWhere((a) => a.id == address.id));
        break;
    }
  }

  void _showAddAddressModal({DeliveryAddress? address}) {
    final isEdit = address != null;
    final labelController = TextEditingController(text: address?.label ?? '');
    final address1Controller = TextEditingController(text: address?.addressLine1 ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final pincodeController = TextEditingController(text: address?.pincode ?? '');
    final instructionsController = TextEditingController(text: address?.instructions ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: AppColors.outline, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text(isEdit ? 'Edit Address' : 'Add Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _modalTextField('Address Label', labelController, 'e.g., Main Warehouse'),
              _modalTextField('Address', address1Controller, 'Street address'),
              Row(
                children: [
                  Expanded(child: _modalTextField('City', cityController, 'City')),
                  const SizedBox(width: 12),
                  Expanded(child: _modalTextField('Pincode', pincodeController, '560001', keyboard: TextInputType.number)),
                ],
              ),
              _modalTextField('Delivery Instructions', instructionsController, 'Optional', maxLines: 2),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (isEdit) {
                      setState(() {
                        address!.label = labelController.text;
                        address.addressLine1 = address1Controller.text;
                        address.city = cityController.text;
                        address.pincode = pincodeController.text;
                        address.instructions = instructionsController.text;
                      });
                    } else {
                      setState(() {
                        _addresses.add(DeliveryAddress(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          label: labelController.text,
                          addressLine1: address1Controller.text,
                          city: cityController.text,
                          pincode: pincodeController.text,
                          instructions: instructionsController.text,
                          isDefault: _addresses.isEmpty,
                        ));
                      });
                    }
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(isEdit ? 'Save Changes' : 'Add Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modalTextField(String label, TextEditingController controller, String hint,
      {TextInputType? keyboard, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

/// Delivery Address Model
class DeliveryAddress {
  final String id;
  String label;
  String addressLine1;
  String city;
  String pincode;
  String instructions;
  bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.label,
    required this.addressLine1,
    required this.city,
    required this.pincode,
    this.instructions = '',
    this.isDefault = false,
  });
}
