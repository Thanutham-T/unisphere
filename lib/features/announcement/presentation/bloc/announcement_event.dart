part of 'announcement_bloc.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object?> get props => [];
}

class GetAnnouncementsEvent extends AnnouncementEvent {
  final String? category;
  final String? priority;
  final int? limit;

  const GetAnnouncementsEvent({
    this.category,
    this.priority,
    this.limit,
  });

  @override
  List<Object?> get props => [category, priority, limit];
}

class GetAnnouncementsByPriorityEvent extends AnnouncementEvent {
  final String priority;
  final int limit;

  const GetAnnouncementsByPriorityEvent({
    required this.priority,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [priority, limit];
}

class GetAnnouncementsByCategoryEvent extends AnnouncementEvent {
  final String category;
  final int limit;

  const GetAnnouncementsByCategoryEvent({
    required this.category,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [category, limit];
}

class CreateAnnouncementEvent extends AnnouncementEvent {
  final String title;
  final String content;
  final String category;
  final String priority;
  final DateTime date;

  const CreateAnnouncementEvent({
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.date,
  });

  @override
  List<Object?> get props => [title, content, category, priority, date];
}

class UpdateAnnouncementEvent extends AnnouncementEvent {
  final int announcementId;
  final String? title;
  final String? content;
  final String? category;
  final String? priority;
  final DateTime? date;

  const UpdateAnnouncementEvent({
    required this.announcementId,
    this.title,
    this.content,
    this.category,
    this.priority,
    this.date,
  });

  @override
  List<Object?> get props => [announcementId, title, content, category, priority, date];
}

class DeleteAnnouncementEvent extends AnnouncementEvent {
  final int announcementId;

  const DeleteAnnouncementEvent({
    required this.announcementId,
  });

  @override
  List<Object?> get props => [announcementId];
}