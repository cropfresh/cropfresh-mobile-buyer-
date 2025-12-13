import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/team_member.dart';

/// Role Badge Colors as per AC5:
/// Admin=Blue, Procurement=Green, Finance=Orange, Receiving=Gray
class RoleColors {
  RoleColors._();

  static Color getBackgroundColor(BuyerRole role) {
    switch (role) {
      case BuyerRole.admin:
        return const Color(0xFFE3F2FD); // Light Blue
      case BuyerRole.procurementManager:
        return const Color(0xFFE8F5E9); // Light Green
      case BuyerRole.financeUser:
        return const Color(0xFFFFF3E0); // Light Orange
      case BuyerRole.receivingStaff:
        return const Color(0xFFF5F5F5); // Light Gray
    }
  }

  static Color getForegroundColor(BuyerRole role) {
    switch (role) {
      case BuyerRole.admin:
        return const Color(0xFF1565C0); // Blue
      case BuyerRole.procurementManager:
        return const Color(0xFF2E7D32); // Green
      case BuyerRole.financeUser:
        return const Color(0xFFF57C00); // Orange
      case BuyerRole.receivingStaff:
        return const Color(0xFF616161); // Gray
    }
  }

  static Color getStatusColor(MemberStatus status) {
    switch (status) {
      case MemberStatus.active:
        return AppColors.success;
      case MemberStatus.pending:
        return const Color(0xFFFFC107); // Yellow/Amber
      case MemberStatus.inactive:
        return AppColors.error;
    }
  }
}

/// Role Badge Widget - Displays color-coded role chip (AC5)
class RoleBadge extends StatelessWidget {
  final BuyerRole role;
  final bool compact;

  const RoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: RoleColors.getBackgroundColor(role),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: RoleColors.getForegroundColor(role),
        ),
      ),
    );
  }
}

/// Status Indicator Widget - Green/Yellow dot (AC5)
class StatusIndicator extends StatelessWidget {
  final MemberStatus status;
  final bool showLabel;

  const StatusIndicator({
    super.key,
    required this.status,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: RoleColors.getStatusColor(status),
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Team Member Avatar with initials (AC5)
class MemberAvatar extends StatelessWidget {
  final TeamMember member;
  final double size;

  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (member.avatarUrl != null && member.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(member.avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: RoleColors.getBackgroundColor(member.role),
      child: Text(
        member.initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
          color: RoleColors.getForegroundColor(member.role),
        ),
      ),
    );
  }
}

/// Team Member List Item - Compact row per UX design (AC5)
class TeamMemberListItem extends StatelessWidget {
  final TeamMember member;
  final bool isCurrentUser;
  final VoidCallback? onEditRole;
  final VoidCallback? onDeactivate;
  final VoidCallback? onDelete;
  final VoidCallback? onResendInvite;

  const TeamMemberListItem({
    super.key,
    required this.member,
    this.isCurrentUser = false,
    this.onEditRole,
    this.onDeactivate,
    this.onDelete,
    this.onResendInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: AppColors.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          MemberAvatar(member: member),
          const SizedBox(width: 12),
          
          // Name, Email, Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'You',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Role Badge
          RoleBadge(role: member.role, compact: true),
          
          const SizedBox(width: 8),
          
          // Status + Last Login
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusIndicator(status: member.status),
                const SizedBox(height: 4),
                Text(
                  member.lastLoginDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Actions Menu (if not current user)
          if (!isCurrentUser)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEditRole?.call();
                    break;
                  case 'deactivate':
                    onDeactivate?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                  case 'resend':
                    onResendInvite?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                if (member.status != MemberStatus.pending)
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('Edit Role'),
                      ],
                    ),
                  ),
                if (member.status == MemberStatus.pending)
                  const PopupMenuItem(
                    value: 'resend',
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 18),
                        SizedBox(width: 12),
                        Text('Resend Invite'),
                      ],
                    ),
                  ),
                if (member.status == MemberStatus.active)
                  PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(Icons.person_off_outlined, size: 18, color: AppColors.warning),
                        const SizedBox(width: 12),
                        Text('Deactivate', style: TextStyle(color: AppColors.warning)),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      const SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
