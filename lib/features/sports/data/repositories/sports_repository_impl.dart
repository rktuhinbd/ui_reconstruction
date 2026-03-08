import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/repositories/sports_repository.dart';
import '../datasources/sports_local_data_source.dart';
import '../datasources/sports_remote_data_source.dart';

class SportsRepositoryImpl implements SportsRepository {
  final SportsRemoteDataSource remoteDataSource;
  final SportsLocalDataSource localDataSource;

  SportsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MatchEvent>>> getLiveMatches() async {
    try {
      final matches = await remoteDataSource.getLiveMatches();
      return Right(matches);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchEvent>>> getMatchesByDate(DateTime date) async {
    try {
      final matches = await remoteDataSource.getMatchesByDate(date);
      return Right(matches);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchEvent>>> getMyGames() async {
    try {
      final matches = await remoteDataSource.getMyGames();
      return Right(matches);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<void> saveFavorites(Set<String> matchIds) async {
    await localDataSource.saveFavorites(matchIds);
  }

  @override
  Future<Set<String>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> saveNotificationStatus(bool isEnabled) async {
    await localDataSource.saveNotificationStatus(isEnabled);
  }

  @override
  Future<bool> getNotificationStatus() async {
    return await localDataSource.getNotificationStatus();
  }

  @override
  Future<void> saveNotifiedMatchIds(Set<String> matchIds) async {
    await localDataSource.saveNotifiedMatchIds(matchIds);
  }

  @override
  Future<Set<String>> getNotifiedMatchIds() async {
    return await localDataSource.getNotifiedMatchIds();
  }
}
