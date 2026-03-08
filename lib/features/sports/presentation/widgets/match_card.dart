import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        bool isNotifEnabled = false;

        if (state is SportsLoaded) {
          isFavorited = state.favoriteMatchIds.contains(match.id);
          isNotifEnabled = state.isNotificationEnabled;
        }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/trophy_icon.png.png', height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, size: 16, color: Colors.orange)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.tournamentName,
                      style: AppTypography.labelSmall.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLive) ...[
                    const Icon(Icons.play_circle_outline, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                  ],
                  GestureDetector(
                    onTap: () => context.read<SportsBloc>().add(RequestNotificationPermission()),
                    child: Icon(
                      isNotifEnabled ? Icons.notifications : Icons.notifications_none, 
                      size: 18, 
                      color: isNotifEnabled ? const Color(0xFFFFD700) : AppColors.textLight
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.read<SportsBloc>().add(ToggleFavorite(match.id)),
                    child: Icon(
                      isFavorited ? Icons.star : Icons.star_border, 
                      size: 18, 
                      color: isFavorited ? const Color(0xFFFFD700) : AppColors.textLight
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(match.tournamentGroup, style: AppTypography.labelSmall),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _TeamRow(
                      name: match.homeTeam.name,
                      logoUrl: match.homeTeam.logoUrl,
                      score: match.homeScore,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TeamRow(
                      name: match.awayTeam.name,
                      logoUrl: match.awayTeam.logoUrl,
                      score: match.awayScore,
                      subtitle: match.matchTime,
                    ),
                  ),
                ],
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
          ),
        );
      }
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
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.transparent,
          child: Image.asset(logoUrl, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
        ),
        if (score != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(score!, style: AppTypography.h3),
              if (subtitle != null)
                Text(subtitle!, style: AppTypography.labelSmall),
            ],
          ),
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
