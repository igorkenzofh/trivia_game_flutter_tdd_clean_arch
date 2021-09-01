import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_tdd_app/core/error/exceptions.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/number_trivia_mock.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(numberTriviaMock));

    test(
        'should return NumberTrivia from SharedPreferences when it exists in the cache',
        () async {
      when(mockSharedPreferences.get(any)).thenReturn(numberTriviaMock);

      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      verify(mockSharedPreferences.get(cachedNumberTrivia));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CacheException when there s not a cached value',
        () async {
      when(mockSharedPreferences.get(any)).thenReturn(null);

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;

      expect(call, throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    test('should call Sharedreferences to cache the data', () async {
      // não da pra testar os dados salvos, entao pular arrange
      final tNumberTriviaModel =
          NumberTriviaModel(text: 'Test Text.', number: 1);
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      verify(mockSharedPreferences.setString(
          numberTriviaMock, '{"text":"Test Text.","number":1}'));
    });
  });
}
