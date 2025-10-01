import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart' as datasource;
import '../models/event_model.dart';
import '../../../../core/errors/exceptions.dart';

@LazySingleton(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final datasource.EventRemoteDataSource _remoteDataSource;

  EventRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Exception, List<Event>>> getEvents() async {
    try {
      final events = await _remoteDataSource.getEvents();
      return Right(events.map((model) => model.toEntity()).toList());
    } on UnauthorizedException catch (e) {
      // ส่ง UnauthorizedException ต่อไปให้ UI layer จัดการ auto logout
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, Event>> getEventById(String eventId) async {
    try {
      final event = await _remoteDataSource.getEventById(eventId);
      return Right(event.toEntity());
    } on UnauthorizedException catch (e) {
      // ส่ง UnauthorizedException ต่อไปให้ UI layer จัดการ auto logout
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, Event>> createEvent({
    required String title,
    String? description,
    String? category,
    String? imageUrl,
    required DateTime date,
    String? location,
    int? maxCapacity,
  }) async {
    try {
      final request = CreateEventRequest(
        title: title,
        description: description,
        category: category,
        imageUrl: imageUrl,
        date: date,
        location: location,
        maxCapacity: maxCapacity,
      );
      
      final event = await _remoteDataSource.createEvent(request);
      return Right(event.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, Event>> updateEvent({
    required String eventId,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    DateTime? date,
    String? location,
    String? status,
    int? maxCapacity, // 🆕 เพิ่ม maxCapacity
  }) async {
    try {
      final request = UpdateEventRequest(
        title: title,
        description: description,
        category: category,
        imageUrl: imageUrl,
        date: date,
        location: location,
        status: status,
        maxCapacity: maxCapacity, // 🆕 เพิ่ม maxCapacity
      );
      
      final event = await _remoteDataSource.updateEvent(eventId, request);
      return Right(event.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> deleteEvent(String eventId) async {
    try {
      await _remoteDataSource.deleteEvent(eventId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> registerForEvent(String eventId) async {
    try {
      await _remoteDataSource.registerForEvent(eventId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> unregisterFromEvent(String eventId) async {
    try {
      await _remoteDataSource.unregisterFromEvent(eventId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Event>>> getUserRegisteredEvents() async {
    try {
      final events = await _remoteDataSource.getUserRegisteredEvents();
      return Right(events.map((model) => model.toEntity()).toList());
    } on UnauthorizedException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}