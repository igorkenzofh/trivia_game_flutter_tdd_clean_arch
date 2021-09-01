import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/usecase/usecase.dart';
import 'package:trivia_tdd_app/core/utils/input_converter.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTriviaUsecase {}

class MockGetRandomNumberTrivia extends Mock
    implements GetRandomNumberTriviaUsecase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialstate should be empty', () {
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTriviaModel(text: 'text', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test('should call the InputConverter to validate and convert the string',
        () async {
      setUpMockInputConverterSuccess();

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit errorState when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete usecase', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
        'should emit the states [Loading, loaded] when data is gotten successfully',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));

      // assert later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit the states [Loading, loaded, Error] when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit the states [Loading, Error] with proper message for the error',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), Error(errorMessage: CACHE_FAILURE_MESSAGE)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTriviaModel(text: 'text', number: 1);

    test('should get data from the concrete usecase', () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'should emit the states [Loading, loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));

      // assert later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit the states [Loading, loaded, Error] when getting data fails',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit the states [Loading, Error] with proper message for the error',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), Error(errorMessage: CACHE_FAILURE_MESSAGE)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
