import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/usecase/usecase.dart';
import 'package:trivia_tdd_app/core/utils/input_converter.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter})
      : assert(getConcreteNumberTrivia != null),
        assert(getRandomNumberTrivia != null),
        assert(inputConverter != null),
        super(Empty());

  final GetConcreteNumberTriviaUsecase getConcreteNumberTrivia;
  final GetRandomNumberTriviaUsecase getRandomNumberTrivia;
  final InputConverter inputConverter;

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      print('inputEither in bloc: $inputEither');

      yield* inputEither.fold(
        (failure) async* {
          yield Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          print('im here at number trivia bloc');
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTriviaEntity> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
