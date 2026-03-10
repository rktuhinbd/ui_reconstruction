import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/sports_bloc.dart';
import '../widgets/date_selector.dart';
import '../widgets/match_card.dart';
import 'common_widgets.dart';

/// Displays upcoming and live matches with a date selector.
class ScheduleTab extends StatelessWidget {
  final SportsLoaded state;

  const ScheduleTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );

    final bool isToday = selectedDay.isAtSameMomentAs(today);
    final bool isPast = selectedDay.isBefore(today);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DateSelector(
          selectedDate: state.selectedDate,
          onDateSelected: (date) =>
              context.read<SportsBloc>().add(LoadMatchesByDate(date)),
        ),
        if (isToday && state.liveMatches.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text('Live events', style: AppTypography.h3),
                const SizedBox(width: 8),
                const GlowingDot(),
              ],
            ),
          ),
          ...state.liveMatches.map((m) => MatchCard(match: m, isLive: true)),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            isPast ? 'Results' : 'Pre-match events',
            style: AppTypography.h3,
          ),
        ),
        ...state.scheduledMatches.map((m) => MatchCard(match: m)),
        const SizedBox(height: 16),
      ],
    );
  }
}
