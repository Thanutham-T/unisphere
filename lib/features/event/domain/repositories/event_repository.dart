import 'package:dartz/dartz.dart';
import '../../domain/entities/event.dart';

abstract class EventRepository {
  Future<Either<Exception, List<Event>>> getEvents();
  Future<Either<Exception, Event>> getEventById(String eventId);
  Future<Either<Exception, Event>> createEvent({
    required String title,
    String? description,
    String? category,
    String? imageUrl,
    required DateTime date,
    String? location,
    int? maxCapacity,
  });
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
  });
  Future<Either<Exception, void>> deleteEvent(String eventId);
  Future<Either<Exception, void>> registerForEvent(String eventId);
  Future<Either<Exception, void>> unregisterFromEvent(String eventId);
  Future<Either<Exception, List<Event>>> getUserRegisteredEvents();
}