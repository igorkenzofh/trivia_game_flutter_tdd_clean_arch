import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_tdd_app/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return integer when string represents an unsigned integer',
        () async {
      final string = '123';

      final result = inputConverter.stringToUnsignedInteger(string);

      expect(result, Right(123));
    });

    test('should return failure when string is not an integer', () async {
      final string = 'abc';

      final result = inputConverter.stringToUnsignedInteger(string);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
