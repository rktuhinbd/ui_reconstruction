import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/repositories/sports_repository.dart';

// Domain entity for Player stats (added for UI-6)
class PlayerStat extends Equatable {
  final String name;
  final String photoUrl;
  final String runs;
  final String strikeRate;

  const PlayerStat({
    required this.name,
    required this.photoUrl,
    required this.runs,
    required this.strikeRate,
  });

  @override
  List<Object?> get props => [name, photoUrl, runs, strikeRate];
}

// Events
abstract class SportsEvent extends Equatable {
  const SportsEvent();
  @override
  List<Object?> get props => [];
}

class LoadInitialData extends SportsEvent {}

class LoadMatchesByDate extends SportsEvent {
  final DateTime date;
  const LoadMatchesByDate(this.date);
  @override
  List<Object?> get props => [date];
}

class ChangeTab extends SportsEvent {
  final int tabIndex;
  const ChangeTab(this.tabIndex);
  @override
  List<Object?> get props => [tabIndex];
}

class RequestNotificationPermission extends SportsEvent {}

class ToggleFavorite extends SportsEvent {
  final String matchId;
  const ToggleFavorite(this.matchId);
  @override
  List<Object?> get props => [matchId];
}

// States
abstract class SportsState extends Equatable {
  const SportsState();
  @override
  List<Object?> get props => [];
}

class SportsInitial extends SportsState {}

class SportsLoading extends SportsState {}

class SportsLoaded extends SportsState {
  final List<MatchEvent> liveMatches;
  final List<MatchEvent> scheduledMatches;
  final List<MatchEvent> myGames;
  final List<PlayerStat> topPlayers;
  final int selectedTab;
  final DateTime selectedDate;
  final bool isNotificationEnabled;
  final Set<String> favoriteMatchIds;

  const SportsLoaded({
    required this.liveMatches,
    required this.scheduledMatches,
    required this.myGames,
    required this.topPlayers,
    this.selectedTab = 0,
    required this.selectedDate,
    this.isNotificationEnabled = false,
    this.favoriteMatchIds = const {},
  });

  @override
  List<Object?> get props => [
    liveMatches, 
    scheduledMatches, 
    myGames, 
    topPlayers, 
    selectedTab, 
    selectedDate, 
    isNotificationEnabled, 
    favoriteMatchIds
  ];

  SportsLoaded copyWith({
    List<MatchEvent>? liveMatches,
    List<MatchEvent>? scheduledMatches,
    List<MatchEvent>? myGames,
    List<PlayerStat>? topPlayers,
    int? selectedTab,
    DateTime? selectedDate,
    bool? isNotificationEnabled,
    Set<String>? favoriteMatchIds,
  }) {
    return SportsLoaded(
      liveMatches: liveMatches ?? this.liveMatches,
      scheduledMatches: scheduledMatches ?? this.scheduledMatches,
      myGames: myGames ?? this.myGames,
      topPlayers: topPlayers ?? this.topPlayers,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDate: selectedDate ?? this.selectedDate,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      favoriteMatchIds: favoriteMatchIds ?? this.favoriteMatchIds,
    );
  }
}

class SportsError extends SportsState {
  final String message;
  const SportsError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SportsBloc extends Bloc<SportsEvent, SportsState> {
  final SportsRepository repository;

  SportsBloc({required this.repository}) : super(SportsInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<LoadMatchesByDate>(_onLoadMatchesByDate);
    on<ChangeTab>(_onTabChanged);
    on<RequestNotificationPermission>(_onNotificationRequested);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<SportsState> emit) async {
    emit(SportsLoading());
    
    final liveResult = await repository.getLiveMatches();
    final initialDate = DateTime(2026, 2, 18);
    final scheduledResult = await repository.getMatchesByDate(initialDate);
    
    final List<MatchEvent> liveRes = liveResult.fold((_) => [], (m) => m);
    final List<MatchEvent> scheduledRes = scheduledResult.fold((_) => [], (m) => m);

    // Load persistent state
    final isNotifEnabled = await repository.getNotificationStatus();
    final favorites = await repository.getFavorites();

    // Mock player data for UI-6 with corrected photo URLs
    final List<PlayerStat> players = [
      const PlayerStat(name: 'Tim Seifert', photoUrl: 'assets/images/players/tim_seifert.png', runs: '333', strikeRate: '124.7'),
      const PlayerStat(name: 'Rahmanullah Gurbaz', photoUrl: 'assets/images/players/rahmanullah_gurbaz.png', runs: '320', strikeRate: '135.2'),
      const PlayerStat(name: 'George Munsey', photoUrl: 'assets/images/players/george_munsey.png', runs: '315', strikeRate: '118.9'),
      const PlayerStat(name: 'Sherfane Rutherford', photoUrl: 'assets/images/players/sherfane_rutherford.png', runs: '298', strikeRate: '142.5'),
      const PlayerStat(name: 'Jacob Bethell', photoUrl: 'assets/images/players/jacob_bethell.png', runs: '285', strikeRate: '128.3'),
    ];

    // Build "My Games" list from favorites across all mock data if necessary, 
    // or just filter from available ones. For reconstruction, we'll filter live and scheduled.
    final List<MatchEvent> allAvailable = [...liveRes, ...scheduledRes];
    final List<MatchEvent> myGamesRes = allAvailable.where((m) => favorites.contains(m.id)).toList();

    emit(SportsLoaded(
      liveMatches: liveRes,
      scheduledMatches: scheduledRes,
      myGames: myGamesRes,
      topPlayers: players,
      selectedDate: initialDate,
      isNotificationEnabled: isNotifEnabled,
      favoriteMatchIds: favorites,
    ));
  }

  Future<void> _onLoadMatchesByDate(LoadMatchesByDate event, Emitter<SportsState> emit) async {
    if (state is SportsLoaded) {
      final currentState = state as SportsLoaded;
      final result = await repository.getMatchesByDate(event.date);
      
      result.fold(
        (failure) => emit(SportsError(failure.message)),
        (matches) => emit(currentState.copyWith(
          scheduledMatches: matches,
          selectedDate: event.date,
        )),
      );
    }
  }

  void _onTabChanged(ChangeTab event, Emitter<SportsState> emit) {
    if (state is SportsLoaded) {
      emit((state as SportsLoaded).copyWith(selectedTab: event.tabIndex));
    }
  }

  Future<void> _onNotificationRequested(RequestNotificationPermission event, Emitter<SportsState> emit) async {
    if (state is SportsLoaded) {
      final currentState = state as SportsLoaded;
      // Simulate permission taking
      final newStatus = !currentState.isNotificationEnabled;
      await repository.saveNotificationStatus(newStatus);
      emit(currentState.copyWith(isNotificationEnabled: newStatus));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<SportsState> emit) async {
    if (state is SportsLoaded) {
      final currentState = state as SportsLoaded;
      final newFavorites = Set<String>.from(currentState.favoriteMatchIds);
      
      if (newFavorites.contains(event.matchId)) {
        newFavorites.remove(event.matchId);
      } else {
        newFavorites.add(event.matchId);
      }
      
      await repository.saveFavorites(newFavorites);

      // Re-filter My Games
      final allAvailable = [...currentState.liveMatches, ...currentState.scheduledMatches];
      final myGamesRes = allAvailable.where((m) => newFavorites.contains(m.id)).toList();

      emit(currentState.copyWith(
        favoriteMatchIds: newFavorites,
        myGames: myGamesRes,
      ));
    }
  }
}
