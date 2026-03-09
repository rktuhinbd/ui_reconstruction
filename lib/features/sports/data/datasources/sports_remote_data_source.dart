import '../models/match_event_model.dart';
import '../../domain/entities/match_event.dart';

abstract class SportsRemoteDataSource {
  Future<List<MatchEventModel>> getMatchesByDate(DateTime date);
  Future<List<MatchEventModel>> getLiveMatches();
  Future<List<MatchEventModel>> getMyGames();
}

class SportsRemoteDataSourceImpl implements SportsRemoteDataSource {
  @override
  Future<List<MatchEventModel>> getLiveMatches() async {
    return [
      MatchEventModel(
        id: '1',
        tournamentName: 'T20 World Cup. 2026. Group stage.',
        tournamentGroup: 'Group D',
        startTime: DateTime.now(),
        homeTeam: const Team(name: 'South Africa', logoUrl: 'assets/flags/sa.png'),
        awayTeam: const Team(name: 'United Arab Emirates', logoUrl: 'assets/flags/uae.png'),
        homeScore: '0/0',
        awayScore: '29/0',
        matchTime: '2.5 ov',
        status: MatchStatus.live,
        odds1X2: [1.075, 25, 8.48],
      ),
    ];
  }

  @override
  Future<List<MatchEventModel>> getMatchesByDate(DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPastDate = date.isBefore(today);

    final year = date.year;
    final month = date.month;
    final day = date.day;

    if (isPastDate) {
      return [
        MatchEventModel(
          id: '${day}_m1',
          tournamentName: 'T20 World Cup. 2026. Group stage.',
          tournamentGroup: 'Group D',
          startTime: DateTime(year, month, day, 19, 0),
          homeTeam: const Team(name: 'New Zealand', logoUrl: 'assets/flags/nz.png'),
          awayTeam: const Team(name: 'Afghanistan', logoUrl: 'assets/flags/afg.png'),
          homeScore: '170/07',
          awayScore: '165/10',
          status: MatchStatus.finished,
        ),
      ];
    }

    return [
      MatchEventModel(
        id: '${day}_m1',
        tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
        tournamentGroup: '${day < 10 ? '0$day' : day}.${month < 10 ? '0$month' : month}.$year 15:30',
        startTime: DateTime(year, month, day, 15, 30),
        homeTeam: const Team(name: 'Pakistan', logoUrl: 'assets/flags/pk.png'),
        awayTeam: const Team(name: 'Namibia', logoUrl: 'assets/flags/na.png'),
        status: MatchStatus.upcoming,
        odds1X2: [1.079, 25, 8.8],
      ),
      MatchEventModel(
        id: '${day}_m2',
        tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
        tournamentGroup: '${day < 10 ? '0$day' : day}.${month < 10 ? '0$month' : month}.$year 19:30',
        startTime: DateTime(year, month, day, 19, 30),
        homeTeam: const Team(name: 'India', logoUrl: 'assets/flags/ind.png'),
        awayTeam: const Team(name: 'Netherlands', logoUrl: 'assets/flags/ned.png'),
        status: MatchStatus.upcoming,
      ),
    ];
  }

  @override
  Future<List<MatchEventModel>> getMyGames() async {
    final now = DateTime.now();
    return [
      MatchEventModel(
        id: '${now.day}_m1',
        tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
        tournamentGroup: 'Upcoming Match',
        startTime: DateTime(now.year, now.month, now.day, 15, 30),
        homeTeam: const Team(name: 'Pakistan', logoUrl: 'assets/flags/pk.png'),
        awayTeam: const Team(name: 'Namibia', logoUrl: 'assets/flags/na.png'),
        status: MatchStatus.upcoming,
        odds1X2: [1.079, 25, 8.8],
      ),
    ];
  }
}
