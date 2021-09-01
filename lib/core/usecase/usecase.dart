import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';

abstract class Usecase<Output, Input> {
  Future<Either<Failure, Output>> call(Input params);
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
