import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/usecase/usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUsecase
    implements Usecase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUsecase(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    print('params in usecase: $params');
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number});

  @override
  // TODO: implement props
  List<Object> get props => [number];
}
