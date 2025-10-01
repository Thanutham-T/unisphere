import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

@injectable
class GetAnnouncementsUseCase {
  final AnnouncementRepository _repository;

  GetAnnouncementsUseCase(this._repository);

  Future<Either<Exception, List<Announcement>>> call({
    int skip = 0,
    int limit = 100,
    String? category,
    String? priority,
  }) async {
    return await _repository.getAnnouncements(
      skip: skip,
      limit: limit,
      category: category,
      priority: priority,
    );
  }
}