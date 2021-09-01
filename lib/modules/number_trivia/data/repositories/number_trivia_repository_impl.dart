import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_tdd_app/core/error/exceptions.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/network/network_info.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo netWorkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.localDataSource,
      @required this.remoteDataSource,
      @required this.netWorkInfo});

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number) async {
    return await _getNumberTrivia(
        () => remoteDataSource.getConcreteNumberTrivia((number)));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(
        () => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _getNumberTrivia(
      Future<NumberTriviaEntity> Function() getConcreteOrRandom) async {
    if (await netWorkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
