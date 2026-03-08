import '../models/match_event_model.dart';
import '../../domain/entities/match_event.dart';

abstract class SportsRemoteDataSource {
  Future<List<MatchEventModel>> getMatchesByDate(DateTime date);
  Future<List<MatchEventModel>> getLiveMatches();
  Future<List<MatchEventModel>> getMyGames();
}

class SportsRemoteDataSourceImpl implements SportsRemoteDataSource {
  // In a real app, this would use Dio. Here we'll provide mock data
  // to ensure the UI can be reconstructed immediately as requested.
  
  @override
  Future<List<MatchEventModel>> getLiveMatches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MatchEventModel(
        id: '1',
        tournamentName: 'T20 World Cup. 2026. Group stage.',
        tournamentGroup: 'Group D',
        startTime: DateTime.now(),
        homeTeam: const Team(name: 'South Africa', logoUrl: 'assets/flags/sa.png'),
        awayTeam: const Team(name: 'United Arab Emirates', logoUrl: 'assets/flags/uae.png'),
        homeScore: '0/0',
        awayScore: '28/0',
        matchTime: '2.3 ov',
        status: MatchStatus.live,
        odds1X2: [1.075, 25, 8.48],
      ),
    ];
  }

  @override
  Future<List<MatchEventModel>> getMatchesByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      MatchEventModel(
        id: '2',
        tournamentName: 'T20 World Cup. 2026. Group stage.',
        tournamentGroup: 'Group A',
        startTime: DateTime(2026, 2, 18, 15, 30),
        homeTeam: const Team(name: 'Pakistan', logoUrl: 'assets/flags/pk.png'),
        awayTeam: const Team(name: 'Namibia', logoUrl: 'assets/flags/na.png'),
        status: MatchStatus.upcoming,
        odds1X2: [1.079, 25, 8.8],
      ),
    ];
  }

  @override
  Future<List<MatchEventModel>> getMyGames() async {
    return [];
  }
}
