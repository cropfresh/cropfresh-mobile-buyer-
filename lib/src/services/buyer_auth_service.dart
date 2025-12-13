import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Buyer Authentication Service
/// Story 2.3: Buyer Business Account Creation & Login
/// Handles login, logout, forgot password, reset password APIs
class BuyerAuthService {
  static const String _baseUrl = 'https://api.cropfresh.in/v1/auth/buyer';
  static const _storage = FlutterSecureStorage();
  
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';

  // ========================================
  // AC7: Buyer Email/Password Login
  // ========================================
  static Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Store tokens
        await _storage.write(key: _tokenKey, value: data['data']['token']);
        await _storage.write(key: _userKey, value: jsonEncode(data['data']['user']));
        
        return LoginResult.success(
          token: data['data']['token'],
          user: BuyerUser.fromJson(data['data']['user']),
        );
      } else if (response.statusCode == 401) {
        return LoginResult.error(
          code: data['error'] ?? 'INVALID_CREDENTIALS',
          message: data['message'] ?? 'Invalid email or password',
        );
      } else if (response.statusCode == 429) {
        return LoginResult.error(
          code: 'ACCOUNT_LOCKED',
          message: data['message'] ?? 'Too many attempts. Try again in 30 minutes.',
        );
      } else {
        return LoginResult.error(
          code: 'UNKNOWN_ERROR',
          message: 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      return LoginResult.error(
        code: 'NETWORK_ERROR',
        message: 'Unable to connect. Check your internet connection.',
      );
    }
  }

  // ========================================
  // AC12: Buyer Logout
  // ========================================
  static Future<bool> logout() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      
      if (token != null) {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      
      // Clear local storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userKey);
      
      return true;
    } catch (e) {
      // Still clear local storage even if API fails
      await _storage.deleteAll();
      return true;
    }
  }

  // ========================================
  // AC9: Forgot Password
  // ========================================
  static Future<ForgotPasswordResult> forgotPassword({
    required String email,
  }) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      // Always return success to prevent email enumeration
      // The API also returns 200 regardless of whether email exists
      return ForgotPasswordResult.success(
        message: 'If this email exists, we\'ve sent a reset link.',
      );
    } catch (e) {
      return ForgotPasswordResult.error(
        message: 'Unable to connect. Check your internet connection.',
      );
    }
  }

  // ========================================
  // AC9: Reset Password
  // ========================================
  static Future<ResetPasswordResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Store new tokens and auto-login
        await _storage.write(key: _tokenKey, value: data['data']['token']);
        await _storage.write(key: _userKey, value: jsonEncode(data['data']['user']));
        
        return ResetPasswordResult.success(
          token: data['data']['token'],
          user: BuyerUser.fromJson(data['data']['user']),
        );
      } else if (response.statusCode == 400) {
        final error = data['error'] ?? 'INVALID_TOKEN';
        if (error == 'TOKEN_EXPIRED') {
          return ResetPasswordResult.error(
            code: 'TOKEN_EXPIRED',
            message: 'Reset link has expired. Request a new one.',
          );
        } else if (error == 'INVALID_PASSWORD') {
          return ResetPasswordResult.error(
            code: 'INVALID_PASSWORD',
            message: data['message'] ?? 'Password does not meet requirements.',
          );
        }
        return ResetPasswordResult.error(
          code: error,
          message: data['message'] ?? 'Invalid reset link.',
        );
      } else {
        return ResetPasswordResult.error(
          code: 'UNKNOWN_ERROR',
          message: 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      return ResetPasswordResult.error(
        code: 'NETWORK_ERROR',
        message: 'Unable to connect. Check your internet connection.',
      );
    }
  }

  // ========================================
  // Session Management
  // ========================================
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<BuyerUser?> getCurrentUser() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      return BuyerUser.fromJson(jsonDecode(userData));
    }
    return null;
  }
}

// ========================================
// Data Models
// ========================================

class BuyerUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? organization;

  BuyerUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.organization,
  });

  factory BuyerUser.fromJson(Map<String, dynamic> json) {
    return BuyerUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'ADMIN',
      organization: json['organization'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'organization': organization,
  };
}

// Result classes for type-safe error handling
class LoginResult {
  final bool success;
  final String? token;
  final BuyerUser? user;
  final String? errorCode;
  final String? errorMessage;

  LoginResult._({
    required this.success,
    this.token,
    this.user,
    this.errorCode,
    this.errorMessage,
  });

  factory LoginResult.success({required String token, required BuyerUser user}) {
    return LoginResult._(success: true, token: token, user: user);
  }

  factory LoginResult.error({required String code, required String message}) {
    return LoginResult._(success: false, errorCode: code, errorMessage: message);
  }
}

class ForgotPasswordResult {
  final bool success;
  final String? message;
  final String? errorMessage;

  ForgotPasswordResult._({
    required this.success,
    this.message,
    this.errorMessage,
  });

  factory ForgotPasswordResult.success({required String message}) {
    return ForgotPasswordResult._(success: true, message: message);
  }

  factory ForgotPasswordResult.error({required String message}) {
    return ForgotPasswordResult._(success: false, errorMessage: message);
  }
}

class ResetPasswordResult {
  final bool success;
  final String? token;
  final BuyerUser? user;
  final String? errorCode;
  final String? errorMessage;

  ResetPasswordResult._({
    required this.success,
    this.token,
    this.user,
    this.errorCode,
    this.errorMessage,
  });

  factory ResetPasswordResult.success({required String token, required BuyerUser user}) {
    return ResetPasswordResult._(success: true, token: token, user: user);
  }

  factory ResetPasswordResult.error({required String code, required String message}) {
    return ResetPasswordResult._(success: false, errorCode: code, errorMessage: message);
  }
}
