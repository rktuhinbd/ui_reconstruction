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
    if (date.day == 17) {
      return [
        MatchEventModel(
          id: 'res1',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group C',
          tournamentGroup: '17.02.2026 (19:00)',
          startTime: DateTime(2026, 2, 17, 19, 0),
          homeTeam: const Team(name: 'Scotland', logoUrl: 'assets/flags/scot.png'),
          awayTeam: const Team(name: 'Nepal', logoUrl: 'assets/flags/nep.png'),
          homeScore: '170/7',
          awayScore: '171/3',
          status: MatchStatus.finished,
        ),
        MatchEventModel(
          id: 'res2',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group D',
          tournamentGroup: '17.02.2026 (11:00)',
          startTime: DateTime(2026, 2, 17, 11, 0),
          homeTeam: const Team(name: 'New Zealand', logoUrl: 'assets/flags/nz.png'),
          awayTeam: const Team(name: 'Canada', logoUrl: 'assets/flags/can.png'),
          homeScore: '176/2',
          awayScore: '173/4',
          status: MatchStatus.finished,
        ),
      ];
    } else if (date.day == 18) {
      return [
        MatchEventModel(
          id: '2',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
          tournamentGroup: '18.02.26 15:30',
          startTime: DateTime(2026, 2, 18, 15, 30),
          homeTeam: const Team(name: 'Pakistan', logoUrl: 'assets/flags/pk.png'),
          awayTeam: const Team(name: 'Namibia', logoUrl: 'assets/flags/na.png'),
          status: MatchStatus.upcoming,
          odds1X2: [1.079, 25, 8.8],
        ),
        MatchEventModel(
          id: '3',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
          tournamentGroup: '18.02.26 19:30',
          startTime: DateTime(2026, 2, 18, 19, 30),
          homeTeam: const Team(name: 'India', logoUrl: 'assets/flags/ind.png'),
          awayTeam: const Team(name: 'Netherlands', logoUrl: 'assets/flags/ned.png'),
          status: MatchStatus.upcoming,
        ),
      ];
    } else if (date.day == 19) {
      return [
        MatchEventModel(
          id: '4',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group C',
          tournamentGroup: '19.02.26 11:30',
          startTime: DateTime(2026, 2, 19, 11, 30),
          homeTeam: const Team(name: 'West Indies', logoUrl: 'assets/flags/wi.png'),
          awayTeam: const Team(name: 'Italy', logoUrl: 'assets/flags/ita.png'),
          status: MatchStatus.upcoming,
          odds1X2: [1.079, 25, 8.8],
        ),
        MatchEventModel(
          id: '5',
          tournamentName: 'T20 World Cup. 2026. Group stage. Group B',
          tournamentGroup: '19.02.26 15:30',
          startTime: DateTime(2026, 2, 19, 15, 30),
          homeTeam: const Team(name: 'Sri Lanka', logoUrl: 'assets/flags/sl.png'),
          awayTeam: const Team(name: 'Zimbabwe', logoUrl: 'assets/flags/zim.png'),
          status: MatchStatus.upcoming,
          odds1X2: [1.41, 25, 3.025],
        ),
      ];
    }
    return [];
  }

  @override
  Future<List<MatchEventModel>> getMyGames() async {
    return [
      MatchEventModel(
        id: '2',
        tournamentName: 'T20 World Cup. 2026. Group stage. Group A',
        tournamentGroup: '18.02.26 15:30',
        startTime: DateTime(2026, 2, 18, 15, 30),
        homeTeam: const Team(name: 'Pakistan', logoUrl: 'assets/flags/pk.png'),
        awayTeam: const Team(name: 'Namibia', logoUrl: 'assets/flags/na.png'),
        status: MatchStatus.upcoming,
        odds1X2: [1.079, 25, 8.8],
      ),
    ];
  }
}
