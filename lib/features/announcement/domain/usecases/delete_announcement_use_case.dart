import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/announcement_repository.dart';

@injectable
class DeleteAnnouncementUseCase {
  final AnnouncementRepository _repository;

  DeleteAnnouncementUseCase(this._repository);

  Future<Either<Exception, void>> call(int announcementId) async {
    return await _repository.deleteAnnouncement(announcementId);
  }
}