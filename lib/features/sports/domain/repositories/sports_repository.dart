import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/match_event.dart';

abstract class SportsRepository {
  Future<Either<Failure, List<MatchEvent>>> getMatchesByDate(DateTime date);
  Future<Either<Failure, List<MatchEvent>>> getLiveMatches();
  Future<Either<Failure, List<MatchEvent>>> getMyGames();
  Future<void> saveFavorites(Set<String> matchIds);
  Future<Set<String>> getFavorites();
  Future<void> saveNotificationStatus(bool isEnabled);
  Future<bool> getNotificationStatus();
}
