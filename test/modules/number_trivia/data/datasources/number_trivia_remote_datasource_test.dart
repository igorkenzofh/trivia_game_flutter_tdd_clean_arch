import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_tdd_app/core/error/exceptions.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
        'should perform a get request on a url with a number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await numberTriviaRemoteDataSourceImpl
          .getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;

      // assert
      expect(call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
        'should perform a get request on a url with a number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();

      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia;

      // assert
      expect(call(), throwsA(isA<ServerException>()));
    });
  });
}
