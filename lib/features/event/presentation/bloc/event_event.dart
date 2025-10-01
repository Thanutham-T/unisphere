import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {}

class LoadEventById extends EventEvent {
  final String eventId;

  const LoadEventById(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CreateEvent extends EventEvent {
  final String title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final DateTime date;
  final String? location;
  final int? maxCapacity;

  const CreateEvent({
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    required this.date,
    this.location,
    this.maxCapacity,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        category,
        imageUrl,
        date,
        location,
        maxCapacity,
      ];
}

class RegisterForEvent extends EventEvent {
  final String eventId;

  const RegisterForEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class UnregisterFromEvent extends EventEvent {
  final String eventId;

  const UnregisterFromEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class UpdateEvent extends EventEvent {
  final String eventId;
  final String? title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final String? location;
  final String? status;
  final DateTime? date;
  final int? maxCapacity; // 🆕 เพิ่ม maxCapacity

  const UpdateEvent({
    required this.eventId,
    this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.location,
    this.status,
    this.date,
    this.maxCapacity, // 🆕 เพิ่ม maxCapacity
  });

  @override
  List<Object?> get props => [
        eventId,
        title,
        description,
        category,
        imageUrl,
        location,
        status,
        date,
        maxCapacity, // 🆕 เพิ่ม maxCapacity
      ];
}

class DeleteEvent extends EventEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class RefreshEvents extends EventEvent {}