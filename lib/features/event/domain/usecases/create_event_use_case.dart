import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class CreateEventParams {
  final String title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final DateTime date;
  final String? location;
  final int? maxCapacity;

  CreateEventParams({
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    required this.date,
    this.location,
    this.maxCapacity,
  });
}

@injectable
class CreateEventUseCase {
  final EventRepository _repository;

  CreateEventUseCase(this._repository);

  Future<Either<Exception, Event>> call(CreateEventParams params) async {
    return await _repository.createEvent(
      title: params.title,
      description: params.description,
      category: params.category,
      imageUrl: params.imageUrl,
      date: params.date,
      location: params.location,
      maxCapacity: params.maxCapacity,
    );
  }
}