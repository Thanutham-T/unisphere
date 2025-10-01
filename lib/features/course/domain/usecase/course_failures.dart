import 'package:unisphere/core/errors/failure.dart';


class AlreadyRegisteredFailure extends Failure {
  const AlreadyRegisteredFailure({String message = 'Already registered'}) : super(message);
}

class InvalidParamsFailure extends Failure {
  const InvalidParamsFailure({String message = 'semester must not be empty'}) : super(message);
}