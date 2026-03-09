import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/sports_bloc.dart';
import '../widgets/date_selector.dart';
import '../widgets/match_card.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({super.key});

  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  late ScrollController _scrollController;
  bool _isAppBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients && _scrollController.offset > (220 - kToolbarHeight)) {
      if (!_isAppBarCollapsed) {
        setState(() {
          _isAppBarCollapsed = true;
        });
      }
    } else {
      if (_isAppBarCollapsed) {
        setState(() {
          _isAppBarCollapsed = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state is SportsInitial || state is SportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SportsError) {
            return Center(child: Text(state.message));
          }

          if (state is SportsLoaded) {
            final iconColor = _isAppBarCollapsed ? AppColors.primaryBlue : Colors.white;
            final appBarColor = _isAppBarCollapsed ? Colors.white : Colors.transparent;

            return DefaultTabController(
              length: 3,
              initialIndex: state.selectedTab,
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      elevation: _isAppBarCollapsed ? 2 : 0,
                      backgroundColor: appBarColor,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/cricket_header.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF0F172A), Color(0xFF334155)],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black54, Colors.transparent],
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 16,
                              bottom: 80,
                              child: Text(
                                "ICC T20 Men's",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: iconColor),
                        onPressed: () {},
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.search, color: iconColor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        Container(
                          color: AppColors.scaffoldBackground,
                          child: Column(
                            children: [
                              Container(
                                height: 42,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TabBar(
                                  onTap: (index) => context.read<SportsBloc>().add(ChangeTab(index)),
                                  dividerColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    color: AppColors.selectedTab,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: AppColors.unselectedTab,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: const [
                                    Tab(text: 'Schedule'),
                                    Tab(text: 'My games'),
                                    Tab(text: 'Statistics'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        60,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    _ScheduleTab(state: state),
                    _MyGamesTab(state: state),
                    _StatisticsTab(state: state),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  final SportsLoaded state;

  const _ScheduleTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DateSelector(
          selectedDate: state.selectedDate,
          onDateSelected: (date) => context.read<SportsBloc>().add(LoadMatchesByDate(date)),
        ),
        if (state.liveMatches.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text('Live events', style: AppTypography.h3),
                const SizedBox(width: 8),
                Container(
                  width: 8, // User's manual tweak
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          ...state.liveMatches.map((m) => MatchCard(match: m, isLive: true)).toList(),
        ],
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text('Pre-match events', style: AppTypography.h3),
        ),
        ...state.scheduledMatches.map((m) => MatchCard(match: m)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MyGamesTab extends StatelessWidget {
  final SportsLoaded state;
  const _MyGamesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('My matches', style: AppTypography.h3),
        ),
        ...state.myGames.map((m) => MatchCard(match: m)).toList(),
        if (state.myGames.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No saved games found', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  final SportsLoaded state;
  const _StatisticsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top players', style: AppTypography.h3),
            TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: AppColors.primaryBlue))),
          ],
        ),
        const SizedBox(height: 16),
        ...state.topPlayers.map((player) => _PlayerStatCard(player: player)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PlayerStatCard extends StatelessWidget {
  final PlayerStat player;
  const _PlayerStatCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              player.photoUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                color: AppColors.tabBackground,
                child: const Icon(Icons.person, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                const Text('New Zealand', style: AppTypography.labelSmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(player.runs, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('SR ${player.strikeRate}', style: AppTypography.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverAppBarDelegate(this.child, this.height);

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
