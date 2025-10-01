import 'package:dartz/dartz.dart';
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<Either<Exception, List<Announcement>>> getAnnouncements({
    int skip = 0,
    int limit = 100,
    String? category,
    String? priority,
  });
  
  Future<Either<Exception, Announcement>> getAnnouncementById(int announcementId);
  
  Future<Either<Exception, Announcement>> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required String priority,
    required DateTime date,
  });
  
  Future<Either<Exception, Announcement>> updateAnnouncement({
    required int announcementId,
    String? title,
    String? content,
    String? category,
    String? priority,
    DateTime? date,
  });
  
  Future<Either<Exception, void>> deleteAnnouncement(int announcementId);
  
  Future<Either<Exception, List<Announcement>>> getAnnouncementsByCategory(
    String category, {
    int limit = 50,
  });
  
  Future<Either<Exception, List<Announcement>>> getHighPriorityAnnouncements({
    int limit = 10,
  });
}