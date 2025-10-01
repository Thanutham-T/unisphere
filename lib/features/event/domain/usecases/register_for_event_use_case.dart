import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/event_repository.dart';

@injectable
class RegisterForEventUseCase {
  final EventRepository _repository;

  RegisterForEventUseCase(this._repository);

  Future<Either<Exception, void>> call(String eventId) async {
    return await _repository.registerForEvent(eventId);
  }
}