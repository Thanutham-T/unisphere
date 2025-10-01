import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/event_repository.dart';

@injectable
class UnregisterFromEventUseCase {
  final EventRepository _repository;

  UnregisterFromEventUseCase(this._repository);

  Future<Either<Exception, void>> call(String eventId) async {
    return await _repository.unregisterFromEvent(eventId);
  }
}