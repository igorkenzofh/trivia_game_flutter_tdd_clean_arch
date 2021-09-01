import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
