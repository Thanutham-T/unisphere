import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEventParams {
  final String eventId;
  final String? title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final String? location;
  final String? status;
  final DateTime? date;
  final int? maxCapacity; // 🆕 เพิ่ม maxCapacity

  UpdateEventParams({
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
}

@injectable
class UpdateEventUseCase {
  final EventRepository _repository;

  UpdateEventUseCase(this._repository);

  Future<Either<Exception, Event>> call(UpdateEventParams params) async {
    return await _repository.updateEvent(
      eventId: params.eventId,
      title: params.title,
      description: params.description,
      category: params.category,
      imageUrl: params.imageUrl,
      location: params.location,
      status: params.status,
      date: params.date,
      maxCapacity: params.maxCapacity, // 🆕 เพิ่ม maxCapacity
    );
  }
}