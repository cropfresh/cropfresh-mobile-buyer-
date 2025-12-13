// Team Member Model for Story 2.4
// Represents a team member/invitation in the buyer organization

enum BuyerRole {
  admin,
  procurementManager,
  financeUser,
  receivingStaff;

  String get displayName {
    switch (this) {
      case BuyerRole.admin:
        return 'Admin';
      case BuyerRole.procurementManager:
        return 'Procurement Manager';
      case BuyerRole.financeUser:
        return 'Finance User';
      case BuyerRole.receivingStaff:
        return 'Receiving Staff';
    }
  }

  String get description {
    switch (this) {
      case BuyerRole.admin:
        return 'Full access, user management, payment authorization';
      case BuyerRole.procurementManager:
        return 'Place orders, view inventory, manage deliveries';
      case BuyerRole.financeUser:
        return 'View invoices, payment history (read-only)';
      case BuyerRole.receivingStaff:
        return 'Confirm deliveries, report quality issues';
    }
  }

  static BuyerRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return BuyerRole.admin;
      case 'PROCUREMENT_MANAGER':
        return BuyerRole.procurementManager;
      case 'FINANCE_USER':
        return BuyerRole.financeUser;
      case 'RECEIVING_STAFF':
        return BuyerRole.receivingStaff;
      default:
        return BuyerRole.receivingStaff;
    }
  }

  String toApiString() {
    switch (this) {
      case BuyerRole.admin:
        return 'ADMIN';
      case BuyerRole.procurementManager:
        return 'PROCUREMENT_MANAGER';
      case BuyerRole.financeUser:
        return 'FINANCE_USER';
      case BuyerRole.receivingStaff:
        return 'RECEIVING_STAFF';
    }
  }
}

enum MemberStatus {
  active,
  pending,
  inactive;

  String get displayName {
    switch (this) {
      case MemberStatus.active:
        return 'Active';
      case MemberStatus.pending:
        return 'Pending';
      case MemberStatus.inactive:
        return 'Inactive';
    }
  }

  static MemberStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return MemberStatus.active;
      case 'PENDING':
        return MemberStatus.pending;
      case 'INACTIVE':
        return MemberStatus.inactive;
      default:
        return MemberStatus.pending;
    }
  }
}

class TeamMember {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final BuyerRole role;
  final MemberStatus status;
  final DateTime? lastLoginAt;
  final DateTime joinedAt;
  final String? avatarUrl;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.lastLoginAt,
    required this.joinedAt,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get lastLoginDisplay {
    if (status == MemberStatus.pending) return 'Never';
    if (lastLoginAt == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${lastLoginAt!.day}/${lastLoginAt!.month}/${lastLoginAt!.year}';
  }

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: BuyerRole.fromString(json['role'] ?? 'RECEIVING_STAFF'),
      status: MemberStatus.fromString(json['status'] ?? 'PENDING'),
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
      joinedAt: json['joined_at'] != null 
          ? DateTime.parse(json['joined_at']) 
          : DateTime.now(),
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toApiString(),
      'status': status.displayName.toUpperCase(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'joined_at': joinedAt.toIso8601String(),
      'avatar_url': avatarUrl,
    };
  }
}

class TeamInvitation {
  final String id;
  final String email;
  final String mobile;
  final BuyerRole role;
  final String? note;
  final DateTime expiresAt;
  final String status;

  TeamInvitation({
    required this.id,
    required this.email,
    required this.mobile,
    required this.role,
    this.note,
    required this.expiresAt,
    required this.status,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory TeamInvitation.fromJson(Map<String, dynamic> json) {
    return TeamInvitation(
      id: json['invitation_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile_number'] ?? json['mobile'] ?? '',
      role: BuyerRole.fromString(json['role'] ?? 'RECEIVING_STAFF'),
      note: json['note'],
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at']) 
          : DateTime.now().add(const Duration(hours: 24)),
      status: json['status'] ?? 'PENDING',
    );
  }
}
