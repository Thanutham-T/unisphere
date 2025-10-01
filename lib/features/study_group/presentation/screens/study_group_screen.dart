import 'package:flutter/material.dart';
import '../../../../config/themes/app_color.dart';
import '../widgets/study_group_card.dart';
import '../../data/models/study_group.dart';
import 'chat_room_screen.dart';

class StudyGroupScreen extends StatefulWidget {
  const StudyGroupScreen({super.key});

  @override
  State<StudyGroupScreen> createState() => _StudyGroupScreenState();
}

class _StudyGroupScreenState extends State<StudyGroupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Mock data - จะต้องแทนที่ด้วย API calls ในอนาคต
  List<StudyGroup> get _mockGroups => [
    StudyGroup(
      id: '1',
      name: 'Japanese',
      description: 'เพื่อน ๆ ครับ วันนี้จารย์สอนใหนครับ?',
      lastMessage: 'เพื่อน ๆ ครับ วันนี้จารย์สอนใหนครับ?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 15, minutes: 9)),
      memberCount: 25,
      unreadCount: 1,
      memberIds: ['user1', 'user2'],
      creatorId: 'user1',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isJoined: true,
    ),
    StudyGroup(
      id: '2',
      name: 'Thai',
      description: 'วันจันทร์ที่ 14 ก.พ. 69 สอบถึงเนื้อหาที่ 1-5 และ สามารถดูกระษาย์ได้ในลิ้ก...',
      lastMessage: 'วันจันทร์ที่ 14 ก.พ. 69 สอบถึงเนื้อหาที่ 1-5 และ สามารถดูกระษาย์ได้ในลิ้ก...',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 11, minutes: 37)),
      memberCount: 30,
      unreadCount: 1,
      memberIds: ['user1', 'user3'],
      creatorId: 'user3',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      isJoined: true,
    ),
    StudyGroup(
      id: '3',
      name: 'Project404',
      description: 'ฝากกันด้วย',
      lastMessage: 'ฝากกันด้วย',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 7, minutes: 45)),
      memberCount: 15,
      unreadCount: 1,
      memberIds: ['user1', 'user4'],
      creatorId: 'user4',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      isJoined: true,
    ),
    StudyGroup(
      id: '4',
      name: 'EiEiGroup',
      description: 'คิดปีป555555555',
      memberCount: 8,
      memberIds: ['user2', 'user3'],
      creatorId: 'user2',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isJoined: false,
    ),
    StudyGroup(
      id: '5',
      name: 'Student101',
      description: 'เฮย โต๊',
      memberCount: 12,
      memberIds: ['user3', 'user4'],
      creatorId: 'user3',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      isJoined: false,
    ),
    StudyGroup(
      id: '6',
      name: 'Math',
      description: 'วันจันทร์ที่ 14 ก.พ. 69 สอบถึงเนื้อหาที่ 1-5 และ สามารถดูกระษาย์ได้ในลิ้ก...',
      memberCount: 18,
      memberIds: ['user1', 'user2', 'user3'],
      creatorId: 'user1',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      isJoined: false,
    ),
  ];

  List<StudyGroup> get _filteredMyGroups {
    final myGroups = _mockGroups.where((group) => group.isJoined).toList();
    if (_searchQuery.isEmpty) return myGroups;
    return myGroups.where((group) => 
      group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (group.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  List<StudyGroup> get _filteredAvailableGroups {
    final availableGroups = _mockGroups.where((group) => !group.isJoined).toList()
      ..addAll([
        StudyGroup(
          id: '7',
          name: 'Requirements',
          description: 'กลุ่มสำหรับวิชา Requirements Engineering',
          memberCount: 22,
          memberIds: ['user2', 'user4'],
          creatorId: 'user2',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          isJoined: false,
        ),
        StudyGroup(
          id: '8',
          name: 'G4_Mobile',
          description: 'กลุ่มพัฒนาแอปมือถือ',
          memberCount: 16,
          memberIds: ['user3', 'user4'],
          creatorId: 'user3',
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
          isJoined: false,
        ),
        StudyGroup(
          id: '9',
          name: 'Valorant',
          description: 'กลุ่มเล่นเกม Valorant',
          memberCount: 35,
          memberIds: ['user1', 'user2', 'user4'],
          creatorId: 'user4',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          isJoined: false,
        ),
      ]);
    
    if (_searchQuery.isEmpty) return availableGroups;
    return availableGroups.where((group) => 
      group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (group.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหากลุ่มนักศึกษา',
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
                            // Create new group - ไม่มี backend ยัง
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ฟีเจอร์สร้างกลุ่มใหม่ยังไม่พร้อมใช้งาน')),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'กลุ่มของฉัน'),
                  Tab(text: 'กลุ่มอื่น ๆ'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Groups Tab
          _buildGroupsList(_filteredMyGroups, isMyGroups: true),
          
          // Other Groups Tab
          _buildGroupsList(_filteredAvailableGroups, isMyGroups: false),
        ],
      ),
    );
  }

  Widget _buildGroupsList(List<StudyGroup> groups, {required bool isMyGroups}) {
    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isMyGroups ? 'ยังไม่ได้เข้าร่วมกลุ่มใดๆ' : 'ไม่พบกลุ่มที่ค้นหา',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return StudyGroupCard(
          group: group,
          onTap: () {
            if (isMyGroups) {
              // Navigate to chat room
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(group: group),
                ),
              );
            } else {
              // Show join group option
              _showJoinGroupDialog(context, group);
            }
          },
          onLeaveGroup: isMyGroups ? () => _showLeaveGroupDialog(context, group) : null,
        );
      },
    );
  }

  void _showJoinGroupDialog(BuildContext context, StudyGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เข้าร่วมกลุ่ม "${group.name}"'),
        content: Text('คุณต้องการเข้าร่วมกลุ่ม ${group.name} หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Join group - ไม่มี backend ยัง
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('การเข้าร่วมกลุ่ม ${group.name} ยังไม่พร้อมใช้งาน')),
              );
            },
            child: const Text('เข้าร่วม'),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupDialog(BuildContext context, StudyGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ออกจากกลุ่ม "${group.name}"'),
        content: Text('คุณต้องการออกจากกลุ่ม ${group.name} หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Leave group - ไม่มี backend ยัง
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('การออกจากกลุ่ม ${group.name} ยังไม่พร้อมใช้งาน')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ออกจากกลุ่ม'),
          ),
        ],
      ),
    );
  }
}