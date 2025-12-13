import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../models/team_member.dart';
import '../../widgets/team_widgets.dart';
import 'invite_team_member_screen.dart';
import 'edit_role_dialog.dart';

/// Team Management Dashboard Screen (AC1, AC5)
/// Displays list of team members with filters, search, pagination
class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  // Filter state
  BuyerRole? _selectedRole;
  MemberStatus? _selectedStatus;
  String _searchQuery = '';
  
  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 10;
  
  // Loading & Data
  bool _isLoading = true;
  List<TeamMember> _members = [];
  String? _currentUserId;
  
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTeamMembers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTeamMembers() async {
    setState(() => _isLoading = true);
    
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data for demonstration
    setState(() {
      _currentUserId = '1';
      _members = _getMockMembers();
      _isLoading = false;
    });
  }

  List<TeamMember> _getMockMembers() {
    return [
      TeamMember(
        id: '1',
        name: 'Rajesh Kumar',
        email: 'rajesh@freshkitchen.com',
        phone: '+919876543210',
        role: BuyerRole.admin,
        status: MemberStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      TeamMember(
        id: '2',
        name: 'Priya Sharma',
        email: 'priya@freshkitchen.com',
        phone: '+919876543211',
        role: BuyerRole.procurementManager,
        status: MemberStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 5)),
        joinedAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      TeamMember(
        id: '3',
        name: 'Amit Patel',
        email: 'amit@freshkitchen.com',
        phone: '+919876543212',
        role: BuyerRole.financeUser,
        status: MemberStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      TeamMember(
        id: '4',
        name: 'Sunita Reddy',
        email: 'sunita@freshkitchen.com',
        phone: '+919876543213',
        role: BuyerRole.receivingStaff,
        status: MemberStatus.pending,
        lastLoginAt: null,
        joinedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TeamMember(
        id: '5',
        name: 'Vikram Singh',
        email: 'vikram@freshkitchen.com',
        phone: '+919876543214',
        role: BuyerRole.receivingStaff,
        status: MemberStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 12)),
        joinedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  List<TeamMember> get _filteredMembers {
    var filtered = _members;
    
    // Filter by role
    if (_selectedRole != null) {
      filtered = filtered.where((m) => m.role == _selectedRole).toList();
    }
    
    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered.where((m) => m.status == _selectedStatus).toList();
    }
    
    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((m) =>
        m.name.toLowerCase().contains(query) ||
        m.email.toLowerCase().contains(query)
      ).toList();
    }
    
    return filtered;
  }

  int get _totalPages => (_filteredMembers.length / _pageSize).ceil();

  List<TeamMember> get _paginatedMembers {
    final start = (_currentPage - 1) * _pageSize;
    final end = start + _pageSize;
    final filtered = _filteredMembers;
    return filtered.sublist(
      start.clamp(0, filtered.length),
      end.clamp(0, filtered.length),
    );
  }

  void _onInviteMember() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InviteTeamMemberScreen(),
      ),
    );
    
    if (result == true) {
      _loadTeamMembers();
    }
  }

  void _onEditRole(TeamMember member) async {
    final newRole = await showDialog<BuyerRole>(
      context: context,
      builder: (context) => EditRoleDialog(
        member: member,
        currentUserId: _currentUserId,
      ),
    );
    
    if (newRole != null && newRole != member.role) {
      // TODO: Call API to update role
      _showSuccessSnackbar('Role updated to ${newRole.displayName}');
      _loadTeamMembers();
    }
  }

  void _onDeactivate(TeamMember member) async {
    final confirm = await _showConfirmDialog(
      title: 'Deactivate Member',
      message: 'Are you sure you want to deactivate ${member.name}? They will no longer be able to access the platform.',
      confirmText: 'Deactivate',
      isDestructive: true,
    );
    
    if (confirm == true) {
      // TODO: Call API to deactivate
      _showSuccessSnackbar('${member.name} has been deactivated');
      _loadTeamMembers();
    }
  }

  void _onDelete(TeamMember member) async {
    final confirm = await _showConfirmDialog(
      title: 'Delete Member',
      message: 'Are you sure you want to delete ${member.name}? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    
    if (confirm == true) {
      // TODO: Call API to delete
      _showSuccessSnackbar('${member.name} has been removed');
      _loadTeamMembers();
    }
  }

  void _onResendInvite(TeamMember member) async {
    // TODO: Call API to resend invite
    _showSuccessSnackbar('Invitation resent to ${member.email}');
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? FilledButton.styleFrom(backgroundColor: AppColors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTeamMembers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters (AC1)
          _buildSearchAndFilters(),
          
          // Member List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMembers.isEmpty
                    ? _buildEmptyState()
                    : _buildMemberList(),
          ),
          
          // Pagination (AC1)
          if (!_isLoading && _filteredMembers.isNotEmpty)
            _buildPagination(),
        ],
      ),
      // Invite FAB (AC1)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onInviteMember,
        icon: const Icon(Icons.person_add),
        label: const Text('Invite'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.5, end: 0),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _currentPage = 1;
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Role Filter
                _buildFilterDropdown<BuyerRole>(
                  value: _selectedRole,
                  hint: 'All Roles',
                  items: BuyerRole.values,
                  labelBuilder: (role) => role.displayName,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                      _currentPage = 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                
                // Status Filter
                _buildFilterDropdown<MemberStatus>(
                  value: _selectedStatus,
                  hint: 'All Status',
                  items: MemberStatus.values,
                  labelBuilder: (status) => status.displayName,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      _currentPage = 1;
                    });
                  },
                ),
                
                // Clear Filters
                if (_selectedRole != null || _selectedStatus != null) ...[
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Clear'),
                    avatar: const Icon(Icons.close, size: 16),
                    onPressed: () {
                      setState(() {
                        _selectedRole = null;
                        _selectedStatus = null;
                        _currentPage = 1;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildFilterDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: value != null ? AppColors.primaryContainer : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: value != null ? AppColors.primary : AppColors.outline,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 13)),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Text(hint),
            ),
            ...items.map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return RefreshIndicator(
      onRefresh: _loadTeamMembers,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: _paginatedMembers.length,
        itemBuilder: (context, index) {
          final member = _paginatedMembers[index];
          final isCurrentUser = member.id == _currentUserId;
          
          return TeamMemberListItem(
            member: member,
            isCurrentUser: isCurrentUser,
            onEditRole: () => _onEditRole(member),
            onDeactivate: () => _onDeactivate(member),
            onDelete: () => _onDelete(member),
            onResendInvite: () => _onResendInvite(member),
          ).animate().fadeIn(
            duration: 200.ms,
            delay: (index * 50).ms,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedRole != null || _selectedStatus != null
                ? 'No members found'
                : 'No team members yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedRole != null || _selectedStatus != null
                ? 'Try adjusting your filters'
                : 'Invite team members to get started',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isEmpty && _selectedRole == null && _selectedStatus == null)
            FilledButton.icon(
              onPressed: _onInviteMember,
              icon: const Icon(Icons.person_add),
              label: const Text('Invite Team Member'),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_paginatedMembers.length} of ${_filteredMembers.length} members',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < _totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
