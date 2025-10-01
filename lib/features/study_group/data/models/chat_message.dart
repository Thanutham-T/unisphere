enum MessageType {
  text,
  image,
  file,
  studentCard,
}

class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String content;
  final MessageType type;
  final DateTime sentAt;
  final List<String> readBy;
  final String? imageUrl;
  final String? fileName;
  final int? fileSize;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.content,
    required this.type,
    required this.sentAt,
    required this.readBy,
    this.imageUrl,
    this.fileName,
    this.fileSize,
  });

  ChatMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? senderImage,
    String? content,
    MessageType? type,
    DateTime? sentAt,
    List<String>? readBy,
    String? imageUrl,
    String? fileName,
    int? fileSize,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      content: content ?? this.content,
      type: type ?? this.type,
      sentAt: sentAt ?? this.sentAt,
      readBy: readBy ?? this.readBy,
      imageUrl: imageUrl ?? this.imageUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}