import 'package:dartz/dartz.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String string) {
    try {
      final integer = int.parse(string);
      if (integer < 0) {
        throw FormatException();
      } else {
        return Right(integer);
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
