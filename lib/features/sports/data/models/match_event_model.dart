import '../../domain/entities/match_event.dart';

class MatchEventModel extends MatchEvent {
  const MatchEventModel({
    required String id,
    required String tournamentName,
    required String tournamentGroup,
    required DateTime startTime,
    required Team homeTeam,
    required Team awayTeam,
    String? homeScore,
    String? awayScore,
    String? matchTime,
    required MatchStatus status,
    List<double>? odds1X2,
  }) : super(
          id: id,
          tournamentName: tournamentName,
          tournamentGroup: tournamentGroup,
          startTime: startTime,
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          homeScore: homeScore,
          awayScore: awayScore,
          matchTime: matchTime,
          status: status,
          odds1X2: odds1X2,
        );

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    return MatchEventModel(
      id: json['id'],
      tournamentName: json['tournamentName'],
      tournamentGroup: json['tournamentGroup'],
      startTime: DateTime.parse(json['startTime']),
      homeTeam: Team(
        name: json['homeTeam']['name'],
        logoUrl: json['homeTeam']['logoUrl'],
      ),
      awayTeam: Team(
        name: json['awayTeam']['name'],
        logoUrl: json['awayTeam']['logoUrl'],
      ),
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      matchTime: json['matchTime'],
      status: MatchStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      odds1X2: (json['odds1X2'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentName': tournamentName,
      'tournamentGroup': tournamentGroup,
      'startTime': startTime.toIso8601String(),
      'homeTeam': {'name': homeTeam.name, 'logoUrl': homeTeam.logoUrl},
      'awayTeam': {'name': awayTeam.name, 'logoUrl': awayTeam.logoUrl},
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchTime': matchTime,
      'status': status.toString().split('.').last,
      'odds1X2': odds1X2,
    };
  }
}
