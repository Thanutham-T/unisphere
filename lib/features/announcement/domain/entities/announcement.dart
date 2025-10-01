import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  final int id;
  final String title;
  final String content;
  final String category;
  final String priority;
  final DateTime date;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? creatorName;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.creatorName,
  });

  // Helper methods
  bool get isHighPriority => priority.toLowerCase() == 'high';
  bool get isMediumPriority => priority.toLowerCase() == 'medium';
  bool get isLowPriority => priority.toLowerCase() == 'low';

  String get priorityDisplayName {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'สำคัญมาก';
      case 'medium':
        return 'สำคัญปานกลาง';
      case 'low':
        return 'สำคัญน้อย';
      default:
        return priority;
    }
  }

  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'academic':
        return 'วิชาการ';
      case 'cultural':
        return 'วัฒนธรรม';
      case 'general':
        return 'ทั่วไป';
      case 'urgent':
        return 'ด่วน';
      case 'student_affairs':
        return 'กิจการนักศึกษา';
      default:
        return category;
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        priority,
        date,
        createdBy,
        createdAt,
        updatedAt,
        creatorName,
      ];
}