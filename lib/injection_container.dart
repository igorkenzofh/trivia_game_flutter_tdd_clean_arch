import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_tdd_app/core/network/network_info.dart';
import 'package:trivia_tdd_app/core/utils/input_converter.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // todo Features - Number Trivia
  // Bloc
  // Se tiver dispose, registrar factory
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));
  // Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUsecase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUsecase(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), netWorkInfo: sl()));

  // DataSources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  // todo Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetWorkInfoImpl(sl()));

  // todo Externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
