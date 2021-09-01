import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/usecase/usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTriviaUsecase usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUsecase(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTriviaEntity(text: 'text', number: 1);

  test('should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer(
        (_) async => Right<Failure, NumberTriviaEntity>(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test('should return SereverFailure when call doesnt succeed', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer(
        (_) async => Left<Failure, NumberTriviaEntity>(ServerFailure()));

    final result = await usecase(NoParams());

    expect(result, Left(ServerFailure()));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
