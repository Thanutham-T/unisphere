import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.category,
    required super.priority,
    required super.date,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
    super.creatorName,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      date: DateTime.parse(json['date'] as String),
      createdBy: json['created_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      creatorName: json['creator_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'date': date.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'creator_name': creatorName,
    };
  }
}

class CreateAnnouncementRequest {
  final String title;
  final String content;
  final String category;
  final String priority;
  final DateTime date;

  const CreateAnnouncementRequest({
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'date': date.toIso8601String(),
    };
  }
}

class UpdateAnnouncementRequest {
  final String? title;
  final String? content;
  final String? category;
  final String? priority;
  final DateTime? date;

  const UpdateAnnouncementRequest({
    this.title,
    this.content,
    this.category,
    this.priority,
    this.date,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (category != null) data['category'] = category;
    if (priority != null) data['priority'] = priority;
    if (date != null) data['date'] = date!.toIso8601String();
    return data;
  }
}
