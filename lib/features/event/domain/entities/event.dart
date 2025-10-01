import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final DateTime date;
  final String? location;
  final String status;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? maxCapacity; // 🆕 Maximum capacity (null = unlimited)
  final int registrationCount;
  final bool isRegistered;
  final bool isFull; // 🆕 Whether event has reached capacity

  const Event({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    required this.date,
    this.location,
    this.status = 'upcoming',
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.maxCapacity, // 🆕
    this.registrationCount = 0,
    this.isRegistered = false,
    this.isFull = false, // 🆕
  });

  bool get isUpcoming => status == 'upcoming';
  bool get isOngoing => status == 'ongoing';
  bool get isCompleted => status == 'completed';
  
  String get statusDisplayName {
    switch (status) {
      case 'upcoming':
        return 'กำลังจะมาถึง';
      case 'ongoing':
        return 'กำลังดำเนินการ';
      case 'completed':
        return 'เสร็จสิ้นแล้ว';
      default:
        return status;
    }
  }

  // 🆕 Helper methods for capacity management
  int? get availableSpots {
    if (maxCapacity == null) return null; // Unlimited
    return maxCapacity! - registrationCount;
  }

  bool get hasCapacityLimit => maxCapacity != null;

  bool get isNearlyFull {
    if (maxCapacity == null) return false;
    return registrationCount >= (maxCapacity! * 0.8); // 80% full
  }

  double get capacityPercentage {
    if (maxCapacity == null) return 0.0;
    return registrationCount / maxCapacity!;
  }

  String get capacityStatusText {
    if (!hasCapacityLimit) return 'ไม่จำกัดจำนวน';
    if (isFull) return 'เต็มแล้ว';
    if (isNearlyFull) return 'เหลืออีก ${availableSpots} ที่นั่ง';
    return 'เหลือ ${availableSpots} ที่นั่ง';
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    DateTime? date,
    String? location,
    String? status,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? maxCapacity, // 🆕
    int? registrationCount,
    bool? isRegistered,
    bool? isFull, // 🆕
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      location: location ?? this.location,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      maxCapacity: maxCapacity ?? this.maxCapacity, // 🆕
      registrationCount: registrationCount ?? this.registrationCount,
      isRegistered: isRegistered ?? this.isRegistered,
      isFull: isFull ?? this.isFull, // 🆕
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        imageUrl,
        date,
        location,
        status,
        createdBy,
        createdAt,
        updatedAt,
        maxCapacity, // 🆕
        registrationCount,
        isRegistered,
        isFull, // 🆕
      ];
}