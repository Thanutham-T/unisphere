import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

@injectable
class GetEventsUseCase {
  final EventRepository _repository;

  GetEventsUseCase(this._repository);

  Future<Either<Exception, List<Event>>> call() async {
    return await _repository.getEvents();
  }
}