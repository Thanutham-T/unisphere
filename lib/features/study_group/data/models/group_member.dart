class GroupMember {
  final String id;
  final String name;
  final String? profileImage;
  final String email;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime joinedAt;
  final bool isAdmin;

  GroupMember({
    required this.id,
    required this.name,
    this.profileImage,
    required this.email,
    this.isOnline = false,
    this.lastSeen,
    required this.joinedAt,
    this.isAdmin = false,
  });

  GroupMember copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? email,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? joinedAt,
    bool? isAdmin,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      joinedAt: joinedAt ?? this.joinedAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}