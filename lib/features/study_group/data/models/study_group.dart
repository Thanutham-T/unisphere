class StudyGroup {
  final String id;
  final String name;
  final String? description;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int memberCount;
  final int unreadCount;
  final String? groupImage;
  final bool isJoined;
  final List<String> memberIds;
  final String creatorId;
  final DateTime createdAt;

  StudyGroup({
    required this.id,
    required this.name,
    this.description,
    this.lastMessage,
    this.lastMessageTime,
    required this.memberCount,
    this.unreadCount = 0,
    this.groupImage,
    this.isJoined = false,
    required this.memberIds,
    required this.creatorId,
    required this.createdAt,
  });

  StudyGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? memberCount,
    int? unreadCount,
    String? groupImage,
    bool? isJoined,
    List<String>? memberIds,
    String? creatorId,
    DateTime? createdAt,
  }) {
    return StudyGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      memberCount: memberCount ?? this.memberCount,
      unreadCount: unreadCount ?? this.unreadCount,
      groupImage: groupImage ?? this.groupImage,
      isJoined: isJoined ?? this.isJoined,
      memberIds: memberIds ?? this.memberIds,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}