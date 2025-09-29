import 'package:flutter/material.dart';
import '../../../../config/themes/app_color.dart';
import '../widgets/message_bubble.dart';
import '../../data/models/study_group.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/group_member.dart';
import 'add_members_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final StudyGroup group;

  const ChatRoomScreen({
    super.key,
    required this.group,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Mock current user ID
  final String _currentUserId = 'current_user';

  // Mock messages data - จะต้องแทนที่ด้วย API calls ในอนาคต
  List<ChatMessage> get _mockMessages => [
    ChatMessage(
      id: '1',
      groupId: widget.group.id,
      senderId: 'user1',
      senderName: 'Thanaphat Chaiyapreuk',
      content: 'ขอบคุณมากครับ เข้าใจง่ายดีสิใคร',
      type: MessageType.text,
      sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
      readBy: [_currentUserId],
    ),
    ChatMessage(
      id: '2',
      groupId: widget.group.id,
      senderId: 'user2',
      senderName: 'Chaiyaphat Limjareon',
      content: 'เพื่อน ๆ ครับ วันนี้จารย์สอนใหนครับ?',
      type: MessageType.text,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15, seconds: 9)),
      readBy: [],
    ),
    ChatMessage(
      id: '3',
      groupId: widget.group.id,
      senderId: 'user3',
      senderName: 'Sukunya Nidtiya',
      content: 'อาจารย์ประกาศว่า ของคอมมิวเนียวันที่ 9 ก.พ. และจบกันใน้วิทยาสวด ตี 11 ก.พ. เวลา 10.00 น.',
      type: MessageType.text,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15, seconds: 13)),
      readBy: [],
    ),
    ChatMessage(
      id: '4',
      groupId: widget.group.id,
      senderId: 'user4',
      senderName: 'Kanokwan Malion',
      content: 'ขอบคุณครับพี่กัน่าทีเดียว',
      type: MessageType.text,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15, seconds: 27)),
      readBy: [],
    ),
    ChatMessage(
      id: '5',
      groupId: widget.group.id,
      senderId: 'user4',
      senderName: 'Kanokwan Malion',
      content: 'โอเคเลยยย',
      type: MessageType.text,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15, seconds: 42)),
      readBy: [],
    ),
    ChatMessage(
      id: '6',
      groupId: widget.group.id,
      senderId: 'user4',
      senderName: 'Kanokwan Malion',
      content: 'Virtual Student Card',
      type: MessageType.studentCard,
      sentAt: DateTime.now().subtract(const Duration(minutes: 15, seconds: 43)),
      readBy: [],
    ),
  ];

  // Mock members data - จะต้องแทนที่ด้วย API calls ในอนาคต
  List<GroupMember> get _mockMembers => [
    GroupMember(
      id: 'user1',
      name: 'Thanaphat Chaiyapreuk',
      email: 'thanaphat@example.com',
      isOnline: true,
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      isAdmin: true,
    ),
    GroupMember(
      id: 'user2',
      name: 'Chaiyaphat Limjareon',
      email: 'chaiyaphat@example.com',
      isOnline: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    GroupMember(
      id: 'user3',
      name: 'Sukunya Nidtiya',
      email: 'sukunya@example.com',
      isOnline: true,
      joinedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    GroupMember(
      id: 'user4',
      name: 'Kanokwan Malion',
      email: 'kanokwan@example.com',
      isOnline: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name),
            Text(
              '${_mockMembers.length} สมาชิก',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          // Members List
          IconButton(
            onPressed: () => _showMembersBottomSheet(context),
            icon: Stack(
              children: [
                const Icon(Icons.group),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      _mockMembers.where((m) => m.isOnline).length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // More Options
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'add_members':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMembersScreen(group: widget.group),
                    ),
                  );
                  break;
                case 'leave_group':
                  _showLeaveGroupDialog(context);
                  break;
                case 'group_info':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ข้อมูลกลุ่มยังไม่พร้อมใช้งาน')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_members',
                child: Row(
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 12),
                    Text('เพิ่มสมาชิก'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'group_info',
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 12),
                    Text('ข้อมูลกลุ่ม'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'leave_group',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 12),
                    Text('ออกจากกลุ่ม', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _mockMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ยังไม่มีข้อความในกลุ่มนี้',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เริ่มต้นการสนทนาได้เลย!',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _mockMessages.length,
                    itemBuilder: (context, index) {
                      final message = _mockMessages[index];
                      return MessageBubble(
                        message: message,
                        isCurrentUser: message.senderId == _currentUserId,
                      );
                    },
                  ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                // Attachment Button
                IconButton(
                  onPressed: () => _showAttachmentOptions(context),
                  icon: const Icon(Icons.attach_file),
                ),
                
                // Camera Button
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์ถ่ายรูปยังไม่พร้อมใช้งาน')),
                    );
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
                
                // Message Input Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'พิมพ์ข้อความ...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                
                // Voice Message Button
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ฟีเจอร์ข้อความเสียงยังไม่พร้อมใช้งาน')),
                    );
                  },
                  icon: const Icon(Icons.mic),
                ),
                
                // Send Button
                IconButton(
                  onPressed: _messageController.text.trim().isEmpty ? null : _sendMessage,
                  icon: Transform.rotate(
                    angle: -0.5,
                    child: Icon(
                      Icons.send,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Send message - ไม่มี backend ยัง
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('การส่งข้อความยังไม่พร้อมใช้งาน')),
    );

    _messageController.clear();
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('รูปภาพ'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์ส่งรูปภาพยังไม่พร้อมใช้งาน')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.green),
              title: const Text('ไฟล์'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์ส่งไฟล์ยังไม่พร้อมใช้งาน')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.badge, color: Colors.purple),
              title: const Text('บัตรนักศึกษา'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์ส่งบัตรนักศึกษายังไม่พร้อมใช้งาน')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMembersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'สมาชิกกลุ่ม',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _mockMembers.length.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Members List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _mockMembers.length,
                  itemBuilder: (context, index) {
                    final member = _mockMembers[index];
                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            backgroundImage: member.profileImage != null 
                                ? NetworkImage(member.profileImage!) 
                                : null,
                            child: member.profileImage == null 
                                ? Icon(Icons.person, color: AppColors.primary)
                                : null,
                          ),
                          
                          // Online Status Indicator
                          if (member.isOnline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              member.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          if (member.isAdmin)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Admin',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        member.isOnline ? 'ออนไลน์' : 'ออฟไลน์',
                        style: TextStyle(
                          color: member.isOnline ? Colors.green : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLeaveGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ออกจากกลุ่ม "${widget.group.name}"'),
        content: const Text('คุณต้องการออกจากกลุ่มนี้หรือไม่? คุณจะไม่สามารถเห็นข้อความในกลุ่มนี้ได้อีก'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to group list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('การออกจากกลุ่ม ${widget.group.name} ยังไม่พร้อมใช้งาน')),
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