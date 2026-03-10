import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/sports_bloc.dart';
import '../widgets/match_card.dart';
import 'common_widgets.dart';

/// Displays personalized content like favorite matches and a team filter.
class MyGamesTab extends StatelessWidget {
  final SportsLoaded state;

  const MyGamesTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: InfoCard(
            icon: Icons.access_time,
            title: 'My bets',
          ),
        ),
        const SizedBox(height: 16),
        const SectionTitle(title: 'My teams'),
        const SizedBox(height: 12),
        TeamFilterRow(
          flags: const ['ind.png', 'sa.png', 'nz.png', 'wi.png', 'pk.png'],
          onFilterTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Filter options clicked'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: "Team's Match"),
        const SizedBox(height: 12),
        if (state.scheduledMatches.isNotEmpty)
          ...state.scheduledMatches.take(2).map((m) => MatchCard(match: m)),
        if (state.scheduledMatches.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No team matches found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// A horizontal scrolling row of country flags used for filtering.
class TeamFilterRow extends StatelessWidget {
  final List<String> flags;
  final VoidCallback onFilterTap;

  const TeamFilterRow({
    super.key,
    required this.flags,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          GestureDetector(
            onTap: onFilterTap,
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tabBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.filter_list,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...flags.map(
            (flag) => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.tabBackground,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/flags/$flag',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                            Icons.flag,
                            size: 24,
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
