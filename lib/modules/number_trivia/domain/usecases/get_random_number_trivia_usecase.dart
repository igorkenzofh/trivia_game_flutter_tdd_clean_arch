import 'package:dartz/dartz.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/usecase/usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUsecase
    implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUsecase(this.repository);
  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
