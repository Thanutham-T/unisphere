import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/event_repository.dart';

@injectable
class DeleteEventUseCase {
  final EventRepository _repository;

  DeleteEventUseCase(this._repository);

  Future<Either<Exception, void>> call(String eventId) async {
    return await _repository.deleteEvent(eventId);
  }
}