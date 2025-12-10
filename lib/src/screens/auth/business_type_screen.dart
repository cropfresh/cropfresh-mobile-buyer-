import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../widgets/step_progress_indicator.dart';

/// Business Type Screen - Screen 4
/// Select from 28 business types organized by category
class BusinessTypeScreen extends StatefulWidget {
  final String businessName;

  const BusinessTypeScreen({
    super.key,
    required this.businessName,
  });

  @override
  State<BusinessTypeScreen> createState() => _BusinessTypeScreenState();
}

class _BusinessTypeScreenState extends State<BusinessTypeScreen> {
  String? _selectedType;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Business types organized by category
  static const Map<String, List<Map<String, dynamic>>> _businessCategories = {
    'Food Service': [
      {'id': 'RESTAURANT', 'name': 'Restaurant', 'icon': Icons.restaurant},
      {'id': 'HOTEL', 'name': 'Hotel', 'icon': Icons.hotel},
      {'id': 'CATERER', 'name': 'Caterer', 'icon': Icons.celebration},
      {'id': 'CANTEEN', 'name': 'Canteen', 'icon': Icons.lunch_dining},
      {'id': 'CLOUD_KITCHEN', 'name': 'Cloud Kitchen', 'icon': Icons.kitchen},
      {'id': 'CAFE', 'name': 'Cafe', 'icon': Icons.local_cafe},
      {'id': 'FAST_FOOD_CHAIN', 'name': 'Fast Food', 'icon': Icons.fastfood},
    ],
    'Retail': [
      {'id': 'SUPERMARKET', 'name': 'Supermarket', 'icon': Icons.store},
      {'id': 'GROCERY_STORE', 'name': 'Grocery Store', 'icon': Icons.storefront},
      {'id': 'HYPERMARKET', 'name': 'Hypermarket', 'icon': Icons.shopping_cart},
      {'id': 'CONVENIENCE_STORE', 'name': 'Convenience Store', 'icon': Icons.local_convenience_store},
      {'id': 'ORGANIC_STORE', 'name': 'Organic Store', 'icon': Icons.eco},
    ],
    'Wholesale': [
      {'id': 'WHOLESALER', 'name': 'Wholesaler', 'icon': Icons.warehouse},
      {'id': 'DISTRIBUTOR', 'name': 'Distributor', 'icon': Icons.local_shipping},
      {'id': 'COMMISSION_AGENT', 'name': 'Commission Agent', 'icon': Icons.handshake},
      {'id': 'TRADER', 'name': 'Trader', 'icon': Icons.swap_horiz},
    ],
    'Processing': [
      {'id': 'FOOD_PROCESSOR', 'name': 'Food Processor', 'icon': Icons.factory},
      {'id': 'JUICE_MANUFACTURER', 'name': 'Juice/Beverage', 'icon': Icons.local_drink},
      {'id': 'FROZEN_FOOD_COMPANY', 'name': 'Frozen Foods', 'icon': Icons.ac_unit},
      {'id': 'PICKLE_MANUFACTURER', 'name': 'Pickles/Preserved', 'icon': Icons.takeout_dining},
    ],
    'Export': [
      {'id': 'EXPORTER', 'name': 'Exporter', 'icon': Icons.flight_takeoff},
      {'id': 'EXPORT_HOUSE', 'name': 'Export House', 'icon': Icons.public},
      {'id': 'INTERNATIONAL_TRADER', 'name': 'International Trader', 'icon': Icons.language},
    ],
    'Institutional': [
      {'id': 'HOSPITAL', 'name': 'Hospital', 'icon': Icons.local_hospital},
      {'id': 'SCHOOL_COLLEGE', 'name': 'School/College', 'icon': Icons.school},
      {'id': 'CORPORATE_CAFETERIA', 'name': 'Corporate Cafeteria', 'icon': Icons.business},
      {'id': 'GOVERNMENT_INSTITUTION', 'name': 'Government', 'icon': Icons.account_balance},
    ],
    'Specialty': [
      {'id': 'FARM_TO_TABLE', 'name': 'Farm to Table', 'icon': Icons.grass},
    ],
  };

  List<MapEntry<String, List<Map<String, dynamic>>>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _businessCategories.entries.toList();
    }
    
    return _businessCategories.entries.map((entry) {
      final filteredTypes = entry.value.where((type) {
        return (type['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
      return MapEntry(entry.key, filteredTypes);
    }).where((entry) => entry.value.isNotEmpty).toList();
  }

  void _selectType(String type) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedType = type;
    });
  }

  void _continueToNextStep() {
    if (_selectedType == null) return;
    
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(
      context,
      '/credentials',
      arguments: {
        'businessName': widget.businessName,
        'businessType': _selectedType,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const StepProgressIndicator(currentStep: 2, totalSteps: 6),
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Scrollable list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return _buildCategorySection(category.key, category.value, index);
                },
              ),
            ),
            
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: _selectedType != null ? _continueToNextStep : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Business Type',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 6),
        
        Text(
          'Select your business category',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: const Duration(milliseconds: 100)).fadeIn(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search business type...',
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
      ),
    ).animate(delay: const Duration(milliseconds: 150)).fadeIn();
  }

  Widget _buildCategorySection(String categoryName, List<Map<String, dynamic>> types, int categoryIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: types.asMap().entries.map((entry) {
            final type = entry.value;
            final isSelected = _selectedType == type['id'];
            
            return _buildTypeChip(
              type['id'] as String,
              type['name'] as String,
              type['icon'] as IconData,
              isSelected,
            );
          }).toList(),
        ),
      ],
    )
        .animate(delay: Duration(milliseconds: 200 + (categoryIndex * 50)))
        .fadeIn()
        .slideX(begin: -0.05, end: 0);
  }

  Widget _buildTypeChip(String id, String name, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectType(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
