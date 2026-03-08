import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/match_event.dart';
import '../../domain/repositories/sports_repository.dart';

// Events
abstract class SportsEvent extends Equatable {
  const SportsEvent();
  @override
  List<Object?> get props => [];
}

class LoadLiveMatches extends SportsEvent {}

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
  final int selectedTab;
  final DateTime selectedDate;

  const SportsLoaded({
    required this.liveMatches,
    required this.scheduledMatches,
    this.selectedTab = 0,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [liveMatches, scheduledMatches, selectedTab, selectedDate];

  SportsLoaded copyWith({
    List<MatchEvent>? liveMatches,
    List<MatchEvent>? scheduledMatches,
    int? selectedTab,
    DateTime? selectedDate,
  }) {
    return SportsLoaded(
      liveMatches: liveMatches ?? this.liveMatches,
      scheduledMatches: scheduledMatches ?? this.scheduledMatches,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDate: selectedDate ?? this.selectedDate,
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
    on<LoadLiveMatches>(_onLoadLiveMatches);
    on<LoadMatchesByDate>(_onLoadMatchesByDate);
    on<ChangeTab>(_onTabChanged);
  }

  Future<void> _onLoadLiveMatches(LoadLiveMatches event, Emitter<SportsState> emit) async {
    emit(SportsLoading());
    final liveResult = await repository.getLiveMatches();
    
    final initialDate = DateTime(2026, 2, 18);
    final scheduledResult = await repository.getMatchesByDate(initialDate);

    // Using fold from dartz to handle results
    final List<MatchEvent> liveRes = liveResult.fold(
      (failure) => [],
      (matches) => matches,
    );

    final List<MatchEvent> scheduledRes = scheduledResult.fold(
      (failure) => [],
      (matches) => matches,
    );

    emit(SportsLoaded(
      liveMatches: liveRes,
      scheduledMatches: scheduledRes,
      selectedDate: initialDate,
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
}
