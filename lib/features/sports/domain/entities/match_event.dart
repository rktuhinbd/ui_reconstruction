import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String name;
  final String logoUrl;

  const Team({required this.name, required this.logoUrl});

  @override
  List<Object> get props => [name, logoUrl];
}

enum MatchStatus { live, upcoming, finished }

class MatchEvent extends Equatable {
  final String id;
  final String tournamentName;
  final String tournamentGroup;
  final DateTime startTime;
  final Team homeTeam;
  final Team awayTeam;
  final String? homeScore;
  final String? awayScore;
  final String? matchTime; // e.g., "2.3 ov" or "19:00"
  final MatchStatus status;
  final List<double>? odds1X2; // [W1, X, W2]

  const MatchEvent({
    required this.id,
    required this.tournamentName,
    required this.tournamentGroup,
    required this.startTime,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.matchTime,
    required this.status,
    this.odds1X2,
  });

  @override
  List<Object?> get props => [
        id,
        tournamentName,
        tournamentGroup,
        startTime,
        homeTeam,
        awayTeam,
        homeScore,
        awayScore,
        matchTime,
        status,
        odds1X2,
      ];
}
