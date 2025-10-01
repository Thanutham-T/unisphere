/// Custom exceptions for event registration
class EventFullException implements Exception {
  final String message;
  const EventFullException(this.message);

  @override
  String toString() => 'EventFullException: $message';
}

class AlreadyRegisteredException implements Exception {
  final String message;
  const AlreadyRegisteredException(this.message);

  @override
  String toString() => 'AlreadyRegisteredException: $message';
}

class EventRegistrationException implements Exception {
  final String message;
  const EventRegistrationException(this.message);

  @override
  String toString() => 'EventRegistrationException: $message';
}