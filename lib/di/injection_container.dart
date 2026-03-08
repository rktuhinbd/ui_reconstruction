import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../features/sports/data/datasources/sports_local_data_source.dart';
import '../features/sports/data/datasources/sports_remote_data_source.dart';
import '../features/sports/data/repositories/sports_repository_impl.dart';
import '../features/sports/domain/repositories/sports_repository.dart';
import '../features/sports/presentation/bloc/sports_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Sports
  // Bloc
  sl.registerFactory(() => SportsBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<SportsRepository>(
    () => SportsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SportsRemoteDataSource>(
    () => SportsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<SportsLocalDataSource>(
    () => SportsLocalDataSourceImpl(sl()),
  );

  // External
  final box = await Hive.openBox('sports_box');
  sl.registerLazySingleton(() => box);
}
