import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_tdd_app/core/error/exceptions.dart';
import 'package:trivia_tdd_app/core/error/failures.dart';
import 'package:trivia_tdd_app/core/network/network_info.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepository numberTriviaRepository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    numberTriviaRepository = NumberTriviaRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        netWorkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body) {
    group('online device', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('online device', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test trivia', number: tNumber);

    final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test('should test if device is connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      numberTriviaRepository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result =
            await numberTriviaRepository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTriviaEntity));
      });

      test(
          'should cache the data locally when the call to remote datasource is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await numberTriviaRepository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to remote datasource is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result =
            await numberTriviaRepository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result =
            await numberTriviaRepository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Right(tNumberTriviaEntity));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result =
            await numberTriviaRepository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Left(CacheFailure()));
      });
    });
  });

  // GET RANDOM NUMBER TRIVIA

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test trivia', number: 123);

    final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test('should test if device is connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      numberTriviaRepository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await numberTriviaRepository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTriviaEntity));
      });

      test(
          'should cache the data locally when the call to remote datasource is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await numberTriviaRepository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to remote datasource is unsuccessful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await numberTriviaRepository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await numberTriviaRepository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Right(tNumberTriviaEntity));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await numberTriviaRepository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
