import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTriviaModel trivia;

  Loaded({@required this.trivia});

  @override
  // TODO: implement props
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String errorMessage;

  Error({@required this.errorMessage});

  @override
  // TODO: implement props
  List<Object> get props => [errorMessage];
}
