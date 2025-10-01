import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_remote_data_source.dart';
import '../models/announcement_model.dart';

@LazySingleton(as: AnnouncementRepository)
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;

  AnnouncementRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Exception, List<Announcement>>> getAnnouncements({
    int skip = 0,
    int limit = 100,
    String? category,
    String? priority,
  }) async {
    try {
      final announcements = await _remoteDataSource.getAnnouncements(
        category: category,
        priority: priority,
        limit: limit,
      );
      return Right(announcements.cast<Announcement>());
    } on ServerException catch (e) {
      return Left(Exception(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, Announcement>> getAnnouncementById(int announcementId) async {
    try {
      final announcements = await _remoteDataSource.getAnnouncements();
      final announcement = announcements.firstWhere(
        (a) => a.id == announcementId,
        orElse: () => throw const NotFoundException('Announcement not found'),
      );
      return Right(announcement);
    } on NotFoundException catch (e) {
      return Left(Exception(e.message));
    } on ServerException catch (e) {
      return Left(Exception(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, Announcement>> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required String priority,
    required DateTime date,
  }) async {
    try {
      final request = CreateAnnouncementRequest(
        title: title,
        content: content,
        category: category,
        priority: priority,
        date: date,
      );
      final announcement = await _remoteDataSource.createAnnouncement(request);
      return Right(announcement);
    } on ServerException catch (e) {
      return Left(Exception(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, Announcement>> updateAnnouncement({
    required int announcementId,
    String? title,
    String? content,
    String? category,
    String? priority,
    DateTime? date,
  }) async {
    try {
      final request = UpdateAnnouncementRequest(
        title: title,
        content: content,
        category: category,
        priority: priority,
      );
      final announcement = await _remoteDataSource.updateAnnouncement(announcementId, request);
      return Right(announcement);
    } on ServerException catch (e) {
      return Left(Exception(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Exception(e.message));
    } on NotFoundException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteAnnouncement(int announcementId) async {
    try {
      await _remoteDataSource.deleteAnnouncement(announcementId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Exception(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Exception(e.message));
    } on NotFoundException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Announcement>>> getAnnouncementsByCategory(
    String category, {
    int limit = 50,
  }) async {
    return getAnnouncements(category: category, limit: limit);
  }

  @override
  Future<Either<Exception, List<Announcement>>> getHighPriorityAnnouncements({
    int limit = 10,
  }) async {
    return getAnnouncements(priority: 'high', limit: limit);
  }
}