import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

@injectable
class GetEventByIdUseCase {
  final EventRepository _repository;

  GetEventByIdUseCase(this._repository);

  Future<Either<Exception, Event>> call(String eventId) async {
    return await _repository.getEventById(eventId);
  }
}