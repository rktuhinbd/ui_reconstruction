import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/match_event.dart';
import '../bloc/sports_bloc.dart';

class MatchCard extends StatelessWidget {
  final MatchEvent match;
  final bool isLive;

  const MatchCard({super.key, required this.match, this.isLive = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SportsBloc, SportsState>(
      builder: (context, state) {
        bool isFavorited = false;
        bool isNotified = false;
        DateTime? selectedDate;

        if (state is SportsLoaded) {
          isFavorited = state.favoriteMatchIds.contains(match.id);
          isNotified = state.notifiedMatchIds.contains(match.id);
          selectedDate = state.selectedDate;
        }

        final bool isUpcoming = match.status == MatchStatus.upcoming;
        final bool isFinished = match.status == MatchStatus.finished;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isUpcoming 
            ? _UpcomingMatchContent(
                match: match, 
                isFavorited: isFavorited, 
                isNotified: isNotified,
                selectedDate: selectedDate,
              )
            : isFinished
                ? _FinishedMatchContent(match: match)
                : _LiveMatchContent(
                    match: match, 
                    isFavorited: isFavorited, 
                    isNotified: isNotified, 
                    isLive: isLive,
                  ),
        );
      }
    );
  }
}

class _FinishedMatchContent extends StatelessWidget {
  final MatchEvent match;

  const _FinishedMatchContent({required this.match});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd.MM.yyyy (HH:mm)').format(match.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header: Trophy + Title
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/trophy_icon.png', height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, size: 16, color: Colors.orange)),
            const SizedBox(width: 4),
            Text(
              '${match.tournamentName}, ${match.startTime.year} ${match.tournamentGroup}',
              style: AppTypography.labelSmall.copyWith(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Team 1 Row
        Row(
          children: [
            Image.asset(match.homeTeam.logoUrl, height: 24, width: 24, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 24)),
            const SizedBox(width: 8),
            Text(match.homeTeam.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(match.homeScore ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        // Team 2 Row
        Row(
          children: [
            Image.asset(match.awayTeam.logoUrl, height: 24, width: 24, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 24)),
            const SizedBox(width: 8),
            Text(match.awayTeam.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(match.awayScore ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        // Centered Date Row
        Center(
          child: Text(
            formattedDate,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16),
        // Additional Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Additional information',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Showing additional information...')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.countdownBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.countdownText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpcomingMatchContent extends StatelessWidget {
  final MatchEvent match;
  final bool isFavorited;
  final bool isNotified;
  final DateTime? selectedDate;

  const _UpcomingMatchContent({
    required this.match,
    required this.isFavorited,
    required this.isNotified,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isCurrentDateSelected = selectedDate != null && 
        selectedDate!.year == now.year && 
        selectedDate!.month == now.month && 
        selectedDate!.day == now.day;

    final String formattedDate = DateFormat('dd MMM, HH:mm').format(match.startTime);

    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/images/trophy_icon.png.png', height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, size: 16, color: Colors.orange)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${match.tournamentName}, ${match.startTime.year}, Stage, ${match.tournamentGroup}',
                style: AppTypography.labelSmall.copyWith(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _CircularIconButton(
              icon: isNotified ? Icons.notifications : Icons.notifications_none,
              color: isNotified ? const Color(0xFFFFD700) : AppColors.textLight,
              onTap: () => context.read<SportsBloc>().add(ToggleMatchNotification(match.id)),
            ),
            const SizedBox(width: 8),
            _CircularIconButton(
              icon: isFavorited ? Icons.star : Icons.star_border,
              color: isFavorited ? const Color(0xFFFFD700) : AppColors.textLight,
              onTap: () => context.read<SportsBloc>().add(ToggleFavorite(match.id)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(match.homeTeam.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Image.asset(match.homeTeam.logoUrl, height: 24, width: 24, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 24)),
            const SizedBox(width: 16),
            const Text('VS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            Image.asset(match.awayTeam.logoUrl, height: 24, width: 24, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 24)),
            const SizedBox(width: 8),
            Text(match.awayTeam.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
        if (isCurrentDateSelected) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CountdownCard(value: '03'),
              const _CountdownSeparator(),
              _CountdownCard(value: '44'),
              const _CountdownSeparator(),
              _CountdownCard(value: '43'),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Text(
          formattedDate,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textLight, fontWeight: FontWeight.w500),
        ),
        if (match.odds1X2 != null) ...[
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _OddsButton(label: 'W1', value: match.odds1X2![0].toString()),
              const SizedBox(width: 12),
              _OddsButton(label: 'X', value: match.odds1X2![1].toString().replaceAll('.0', '')),
              const SizedBox(width: 12),
              _OddsButton(label: 'W2', value: match.odds1X2![2].toString()),
            ],
          ),
        ],
      ],
    );
  }
}

class _CountdownCard extends StatelessWidget {
  final String value;
  const _CountdownCard({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.countdownBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.countdownText,
        ),
      ),
    );
  }
}

class _CountdownSeparator extends StatelessWidget {
  const _CountdownSeparator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: AppColors.countdownText,
        ),
      ),
    );
  }
}

class _LiveMatchContent extends StatelessWidget {
  final MatchEvent match;
  final bool isFavorited;
  final bool isNotified;
  final bool isLive;

  const _LiveMatchContent({
    required this.match,
    required this.isFavorited,
    required this.isNotified,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Image.asset('assets/images/trophy_icon.png.png', height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, size: 16, color: Colors.orange)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.tournamentName,
                    style: AppTypography.labelSmall.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.tournamentGroup, 
                    style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isLive) ...[
              _CircularIconButton(
                icon: Icons.play_arrow,
                color: AppColors.primaryBlue,
                onTap: () {},
              ),
              const SizedBox(width: 8),
            ],
            _CircularIconButton(
              icon: isNotified ? Icons.notifications : Icons.notifications_none,
              color: isNotified ? const Color(0xFFFFD700) : AppColors.textLight,
              onTap: () => context.read<SportsBloc>().add(ToggleMatchNotification(match.id)),
            ),
            const SizedBox(width: 8),
            _CircularIconButton(
              icon: isFavorited ? Icons.star : Icons.star_border,
              color: isFavorited ? const Color(0xFFFFD700) : AppColors.textLight,
              onTap: () => context.read<SportsBloc>().add(ToggleFavorite(match.id)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'T20', 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textLight),
        ),
        const SizedBox(height: 4),
        _TeamRow(
          name: match.homeTeam.name,
          logoUrl: match.homeTeam.logoUrl,
          score: match.homeScore,
        ),
        const SizedBox(height: 12),
        _TeamRow(
          name: match.awayTeam.name,
          logoUrl: match.awayTeam.logoUrl,
          score: match.awayScore,
          subtitle: match.matchTime,
        ),
        if (match.odds1X2 != null) ...[
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _OddsButton(label: 'W1', value: match.odds1X2![0].toString()),
              const SizedBox(width: 12),
              _OddsButton(label: 'X', value: match.odds1X2![1].toString().replaceAll('.0', '')),
              const SizedBox(width: 12),
              _OddsButton(label: 'W2', value: match.odds1X2![2].toString()),
            ],
          ),
        ],
      ],
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircularIconButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String name;
  final String logoUrl;
  final String? score;
  final String? subtitle;

  const _TeamRow({required this.name, required this.logoUrl, this.score, this.subtitle});

  @override
  Widget build(BuildContext context) {
    // Single line formatting: 28/0 (2.3 ov)
    String scoreText = "";
    if (score != null) {
      scoreText = score!;
      if (subtitle != null) {
        scoreText += " ($subtitle)";
      }
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.transparent,
          child: Image.asset(logoUrl, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        if (scoreText.isNotEmpty)
          Text(scoreText, style: AppTypography.h3.copyWith(fontSize: 14)),
      ],
    );
  }
}

class _OddsButton extends StatelessWidget {
  final String label;
  final String value;

  const _OddsButton({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelSmall),
            Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
