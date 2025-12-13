import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team_member.dart';

/// Team API Service - Handles all team management API calls
/// Implements REST endpoints for AC1-AC9
class TeamApiService {
  static const String _baseUrl = 'http://localhost:3000/v1';
  
  final String? _authToken;

  TeamApiService({String? authToken}) : _authToken = authToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  /// List team members with pagination and filters (AC1, AC5)
  Future<TeamListResponse> listTeamMembers({
    int page = 1,
    int limit = 10,
    BuyerRole? role,
    MemberStatus? status,
    String? search,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (role != null) params['role'] = role.toApiString();
    if (status != null) params['status'] = status.displayName.toUpperCase();
    if (search != null && search.isNotEmpty) params['search'] = search;

    final uri = Uri.parse('$_baseUrl/buyer/team').replace(queryParameters: params);
    
    final response = await http.get(uri, headers: _headers);
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TeamListResponse.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  /// Invite a new team member (AC2, AC3)
  Future<TeamInvitation> inviteTeamMember({
    required String email,
    required String mobileNumber,
    required BuyerRole role,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/buyer/team/invite'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'mobile_number': '+91$mobileNumber',
        'role': role.toApiString(),
        if (note != null && note.isNotEmpty) 'note': note,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return TeamInvitation.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  /// Accept a team invitation (AC4)
  Future<AcceptInvitationResponse> acceptInvitation({
    required String token,
    required String fullName,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/buyer/team/accept-invite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'full_name': fullName,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return AcceptInvitationResponse.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  /// Update a team member's role (AC6)
  Future<RoleUpdateResponse> updateMemberRole({
    required String memberId,
    required BuyerRole newRole,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/buyer/team/$memberId/role'),
      headers: _headers,
      body: jsonEncode({'role': newRole.toApiString()}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RoleUpdateResponse.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  /// Deactivate a team member (AC7)
  Future<void> deactivateMember(String memberId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/buyer/team/$memberId/deactivate'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  /// Delete a team member (AC7)
  Future<void> deleteMember(String memberId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/buyer/team/$memberId'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw _parseError(response);
    }
  }

  /// Resend a pending invitation (AC9)
  Future<TeamInvitation> resendInvitation(String invitationId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/buyer/team/invite/$invitationId/resend'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TeamInvitation.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  /// Validate an invitation token (for accept-invite screen)
  Future<InvitationValidation> validateInvitationToken(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/buyer/team/invitation/$token'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return InvitationValidation.fromJson(json['data']);
    } else {
      throw _parseError(response);
    }
  }

  TeamApiException _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      return TeamApiException(
        code: json['error'] ?? 'UNKNOWN_ERROR',
        message: json['message'] ?? 'An unexpected error occurred',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return TeamApiException(
        code: 'PARSE_ERROR',
        message: 'Failed to parse server response',
        statusCode: response.statusCode,
      );
    }
  }
}

// Response Models

class TeamListResponse {
  final List<TeamMember> members;
  final Pagination pagination;

  TeamListResponse({required this.members, required this.pagination});

  factory TeamListResponse.fromJson(Map<String, dynamic> json) {
    return TeamListResponse(
      members: (json['members'] as List)
          .map((m) => TeamMember.fromJson(m))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class AcceptInvitationResponse {
  final String token;
  final TeamMember user;

  AcceptInvitationResponse({required this.token, required this.user});

  factory AcceptInvitationResponse.fromJson(Map<String, dynamic> json) {
    return AcceptInvitationResponse(
      token: json['token'] ?? '',
      user: TeamMember.fromJson(json['user']),
    );
  }
}

class RoleUpdateResponse {
  final String memberId;
  final BuyerRole oldRole;
  final BuyerRole newRole;

  RoleUpdateResponse({
    required this.memberId,
    required this.oldRole,
    required this.newRole,
  });

  factory RoleUpdateResponse.fromJson(Map<String, dynamic> json) {
    return RoleUpdateResponse(
      memberId: json['member_id'] ?? '',
      oldRole: BuyerRole.fromString(json['old_role'] ?? ''),
      newRole: BuyerRole.fromString(json['new_role'] ?? ''),
    );
  }
}

class InvitationValidation {
  final bool valid;
  final String? email;
  final String? businessName;
  final BuyerRole? role;
  final DateTime? expiresAt;

  InvitationValidation({
    required this.valid,
    this.email,
    this.businessName,
    this.role,
    this.expiresAt,
  });

  factory InvitationValidation.fromJson(Map<String, dynamic> json) {
    return InvitationValidation(
      valid: json['valid'] ?? false,
      email: json['email'],
      businessName: json['business_name'],
      role: json['role'] != null ? BuyerRole.fromString(json['role']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    );
  }
}

class TeamApiException implements Exception {
  final String code;
  final String message;
  final int statusCode;

  TeamApiException({
    required this.code,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => message;

  bool get isDuplicateEmail => code == 'DUPLICATE_EMAIL';
  bool get isInvitationExpired => code == 'INVITATION_EXPIRED';
  bool get isInvalidToken => code == 'INVALID_TOKEN';
  bool get isUnauthorized => code == 'UNAUTHORIZED_ACTION';
  bool get isLastAdmin => code == 'LAST_ADMIN';
}
