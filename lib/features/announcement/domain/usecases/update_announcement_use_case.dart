import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class UpdateAnnouncementParams {
  final int announcementId;
  final String? title;
  final String? content;
  final String? category;
  final String? priority;
  final DateTime? date;

  UpdateAnnouncementParams({
    required this.announcementId,
    this.title,
    this.content,
    this.category,
    this.priority,
    this.date,
  });
}

@injectable
class UpdateAnnouncementUseCase {
  final AnnouncementRepository _repository;

  UpdateAnnouncementUseCase(this._repository);

  Future<Either<Exception, Announcement>> call(UpdateAnnouncementParams params) async {
    return await _repository.updateAnnouncement(
      announcementId: params.announcementId,
      title: params.title,
      content: params.content,
      category: params.category,
      priority: params.priority,
      date: params.date,
    );
  }
}