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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DateSelector(
          selectedDate: state.selectedDate,
          onDateSelected: (date) =>
              context.read<SportsBloc>().add(LoadMatchesByDate(date)),
        ),
        if (state.liveMatches.isNotEmpty) ...[
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
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Pre-match events', style: AppTypography.h3),
        ),
        ...state.scheduledMatches.map((m) => MatchCard(match: m)),
        const SizedBox(height: 16),
      ],
    );
  }
}
