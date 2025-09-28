import 'package:flutter/material.dart';
import '../../../../config/themes/app_color.dart';
import '../widgets/member_card.dart';
import '../../data/models/study_group.dart';
import '../../data/models/group_member.dart';

class AddMembersScreen extends StatefulWidget {
  final StudyGroup group;

  const AddMembersScreen({
    super.key,
    required this.group,
  });

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedMemberIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mock available users data - จะต้องแทนที่ด้วย API calls ในอนาคต
  List<GroupMember> get _mockAvailableUsers => [
    GroupMember(
      id: 'user5',
      name: 'Dechawat Rattanchai',
      email: 'dechawat@example.com',
      isOnline: true,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user6',
      name: 'Thanawan Wanthana',
      email: 'thanawan@example.com',
      isOnline: false,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user7',
      name: 'Pakkaraporn Rungthip',
      email: 'pakkaraporn@example.com',
      isOnline: true,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user8',
      name: 'Thanaphat Chaiyapreuk',
      email: 'thanaphat2@example.com',
      isOnline: false,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user9',
      name: 'Chaiyaphat Limjareon',
      email: 'chaiyaphat2@example.com',
      isOnline: true,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user10',
      name: 'Kanokwan Malion',
      email: 'kanokwan2@example.com',
      isOnline: false,
      joinedAt: DateTime.now(),
    ),
    GroupMember(
      id: 'user11',
      name: 'Sukunya Nidtiya',
      email: 'sukunya2@example.com',
      isOnline: true,
      joinedAt: DateTime.now(),
    ),
  ];

  List<GroupMember> get _filteredUsers {
    List<GroupMember> availableUsers = _mockAvailableUsers
        .where((user) => !widget.group.memberIds.contains(user.id))
        .toList();

    if (_searchQuery.isEmpty) return availableUsers;
    
    return availableUsers.where((user) => 
      user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.email.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
        actions: [
          // Selected count indicator
          if (_selectedMemberIds.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group_add, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _selectedMemberIds.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          // Add selected members button
          IconButton(
            onPressed: _selectedMemberIds.isEmpty ? null : _addSelectedMembers,
            icon: Transform.rotate(
              angle: -0.5,
              child: Icon(
                Icons.send,
                color: _selectedMemberIds.isEmpty 
                    ? Colors.grey 
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: widget.group.groupImage != null 
                          ? NetworkImage(widget.group.groupImage!) 
                          : null,
                      child: widget.group.groupImage == null 
                          ? Icon(Icons.group, color: AppColors.primary, size: 20)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.group.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.group.memberCount} สมาชิก',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหาเพื่อน',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Voice search - ไม่มี backend ยัง
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ฟีเจอร์ค้นหาด้วยเสียงยังไม่พร้อมใช้งาน')),
                            );
                          },
                          icon: const Icon(Icons.mic),
                        ),
                        IconButton(
                          onPressed: () {
                            // Bluetooth search - ไม่มี backend ยัง
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ฟีเจอร์ค้นหาผ่าน Bluetooth ยังไม่พร้อมใช้งาน')),
                            );
                          },
                          icon: const Icon(Icons.bluetooth),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Users List
          Expanded(
            child: _buildUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    final filteredUsers = _filteredUsers;
    
    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.group_off : Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty 
                  ? 'ไม่มีผู้ใช้ที่สามารถเพิ่มได้' 
                  : 'ไม่พบผู้ใช้ที่ค้นหา',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'ทุกคนในมหาวิทยาลัยได้เข้าร่วมกลุ่มนี้แล้ว',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        final isSelected = _selectedMemberIds.contains(user.id);
        
        return MemberCard(
          member: user,
          isSelected: isSelected,
          showSelection: true,
          onSelectionChanged: (selected) {
            setState(() {
              if (selected) {
                _selectedMemberIds.add(user.id);
              } else {
                _selectedMemberIds.remove(user.id);
              }
            });
          },
        );
      },
    );
  }

  void _addSelectedMembers() {
    if (_selectedMemberIds.isEmpty) return;

    // Add members - ไม่มี backend ยัง
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('การเพิ่มสมาชิก ${_selectedMemberIds.length} คน ยังไม่พร้อมใช้งาน'),
      ),
    );

    // Go back to chat room
    Navigator.pop(context);
  }
}