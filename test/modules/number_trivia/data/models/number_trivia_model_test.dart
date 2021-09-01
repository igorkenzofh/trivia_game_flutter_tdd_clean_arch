import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/number_trivia_mock.dart';

void main() {
  NumberTriviaModel tNumberTriviaModel;

  setUp(() {
    tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text.');
  });

  test('should be a subclass of a NumberTriviaEntity', () async {
    expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
  });

  group('fromJson', () {
    test('should return a valid model when the json number is an integer',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap = jsonDecode(numberTriviaMock);

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a json map containing the correct data', () async {
      // Arrange
      final expectedMap = {
        "text": "Test Text.",
        "number": 1,
      };
      final result = tNumberTriviaModel.toJson();

      expect(result, expectedMap);
    });
  });
}
