import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/team_member.dart';
import '../../widgets/team_widgets.dart';

/// Confirmation Dialogs for Team Management (AC7)
/// Deactivate and Delete member confirmation dialogs

class DeactivateMemberDialog extends StatelessWidget {
  final TeamMember member;

  const DeactivateMemberDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_off_outlined,
          color: AppColors.warning,
          size: 32,
        ),
      ),
      title: const Text('Deactivate Member?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Member info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                MemberAvatar(member: member, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        member.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This member will no longer be able to access the platform. Their active sessions will be revoked immediately.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
          child: const Text('Deactivate'),
        ),
      ],
    );
  }
}

class DeleteMemberDialog extends StatelessWidget {
  final TeamMember member;

  const DeleteMemberDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.delete_forever,
          color: AppColors.error,
          size: 32,
        ),
      ),
      title: const Text('Delete Member?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Member info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                MemberAvatar(member: member, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        member.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This action cannot be undone. The member will be permanently removed from your organization.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

/// Last Admin Error Dialog (AC7)
class LastAdminErrorDialog extends StatelessWidget {
  final String action; // 'deactivate', 'delete', or 'change role'

  const LastAdminErrorDialog({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.infoBg,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.admin_panel_settings,
          color: AppColors.info,
          size: 32,
        ),
      ),
      title: const Text('Action Not Allowed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cannot $action the last Admin.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your organization must have at least one Admin. Promote another member to Admin first.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

/// Self Action Error Dialog (AC7)
class SelfActionErrorDialog extends StatelessWidget {
  final String action; // 'deactivate' or 'delete'

  const SelfActionErrorDialog({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.block,
          color: AppColors.warning,
          size: 32,
        ),
      ),
      title: const Text('Cannot Perform Action'),
      content: Text(
        'You cannot $action yourself. Please contact another Admin if you need to leave the organization.',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
