import 'dart:convert';
import 'package:http/http.dart' as http;

/// Buyer Profile Service - Story 2.7
/// API layer for buyer profile and delivery address operations
class ProfileService {
  static const String _baseUrl = 'http://localhost:3000/v1';
  
  final String? _authToken;
  
  ProfileService({String? authToken}) : _authToken = authToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  /// Get current buyer profile
  Future<BuyerProfile> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BuyerProfile.fromJson(data['data']['profile']);
      } else {
        throw ProfileException('Failed to load profile');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }

  /// Update buyer profile
  Future<void> updateProfile({
    String? businessName,
    String? qualityPreference,
    String? orderFrequency,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (businessName != null) body['business_name'] = businessName;
      if (qualityPreference != null) body['quality_preference'] = qualityPreference;
      if (orderFrequency != null) body['order_frequency'] = orderFrequency;

      final response = await http.patch(
        Uri.parse('$_baseUrl/users/profile'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw ProfileException(error['error']?['message'] ?? 'Update failed');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }

  /// Get delivery addresses
  Future<List<DeliveryAddressModel>> getAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/buyers/addresses'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addresses = data['data']['addresses'] as List;
        return addresses.map((a) => DeliveryAddressModel.fromJson(a)).toList();
      } else {
        throw ProfileException('Failed to load addresses');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }

  /// Add delivery address
  Future<DeliveryAddressModel> addAddress({
    required String label,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String pincode,
    String? instructions,
    bool isDefault = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/buyers/addresses'),
        headers: _headers,
        body: jsonEncode({
          'label': label,
          'address_line1': addressLine1,
          'address_line2': addressLine2 ?? '',
          'city': city,
          'pincode': pincode,
          'instructions': instructions ?? '',
          'is_default': isDefault,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return DeliveryAddressModel.fromJson(data['data']['address']);
      } else {
        final error = jsonDecode(response.body);
        throw ProfileException(error['error']?['message'] ?? 'Add failed');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }

  /// Update delivery address
  Future<DeliveryAddressModel> updateAddress(int id, {
    String? label,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? pincode,
    String? instructions,
    bool? isDefault,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (label != null) body['label'] = label;
      if (addressLine1 != null) body['address_line1'] = addressLine1;
      if (addressLine2 != null) body['address_line2'] = addressLine2;
      if (city != null) body['city'] = city;
      if (pincode != null) body['pincode'] = pincode;
      if (instructions != null) body['instructions'] = instructions;
      if (isDefault != null) body['is_default'] = isDefault;

      final response = await http.put(
        Uri.parse('$_baseUrl/buyers/addresses/$id'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeliveryAddressModel.fromJson(data['data']['address']);
      } else {
        final error = jsonDecode(response.body);
        throw ProfileException(error['error']?['message'] ?? 'Update failed');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }

  /// Delete delivery address
  Future<void> deleteAddress(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/buyers/addresses/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw ProfileException(error['error']?['message'] ?? 'Delete failed');
      }
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Network error: $e');
    }
  }
}

/// Buyer Profile Model
class BuyerProfile {
  final int id;
  final String businessName;
  final String? qualityPreference;
  final String? orderFrequency;

  BuyerProfile({
    required this.id,
    required this.businessName,
    this.qualityPreference,
    this.orderFrequency,
  });

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    return BuyerProfile(
      id: json['id'] ?? 0,
      businessName: json['business_name'] ?? '',
      qualityPreference: json['quality_preference'],
      orderFrequency: json['order_frequency'],
    );
  }
}

/// Delivery Address Model
class DeliveryAddressModel {
  final int id;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String pincode;
  final String? instructions;
  final bool isDefault;

  DeliveryAddressModel({
    required this.id,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.pincode,
    this.instructions,
    this.isDefault = false,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'],
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      instructions: json['instructions'],
      isDefault: json['is_default'] ?? false,
    );
  }
}

/// Profile Exception
class ProfileException implements Exception {
  final String message;
  ProfileException(this.message);
  
  @override
  String toString() => message;
}
