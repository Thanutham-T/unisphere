/// Custom exceptions for API and network errors
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  
  @override
  String toString() => 'ServerException: $message';
}

class BadRequestException implements Exception {
  final String message;
  const BadRequestException(this.message);
  
  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException(this.message);
  
  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
  
  @override
  String toString() => 'NotFoundException: $message';
}
