import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTriviaUsecase usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUsecase(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTriviaEntity(text: 'text', number: 1);

  test('should get trivia for the number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Right<Failure, NumberTriviaEntity>(tNumberTrivia));

    final result = await usecase(Params(number: tNumber));

    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test('should return ServerFailure when it doesnt succeed', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Left<Failure, NumberTriviaEntity>(ServerFailure()));

    final result = await usecase(Params(number: tNumber));

    expect(result, Left(ServerFailure()));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
