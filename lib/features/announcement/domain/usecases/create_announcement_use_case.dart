import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class CreateAnnouncementParams {
  final String title;
  final String content;
  final String category;
  final String priority;
  final DateTime date;

  CreateAnnouncementParams({
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.date,
  });
}

@injectable
class CreateAnnouncementUseCase {
  final AnnouncementRepository _repository;

  CreateAnnouncementUseCase(this._repository);

  Future<Either<Exception, Announcement>> call(CreateAnnouncementParams params) async {
    return await _repository.createAnnouncement(
      title: params.title,
      content: params.content,
      category: params.category,
      priority: params.priority,
      date: params.date,
    );
  }
}