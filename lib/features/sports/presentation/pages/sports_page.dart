import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/sports_bloc.dart';
import '../widgets/date_selector.dart';
import '../widgets/match_card.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

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
            return DefaultTabController(
              length: 3,
              initialIndex: state.selectedTab,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/cricket_header.png',
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
                                'ICC T20 Men\'s',
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
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search),
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
                                margin: const EdgeInsets.all(16),
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
                        100,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    _ScheduleTab(state: state),
                    _MyGamesTab(),
                    _StatisticsTab(),
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSelector(
                selectedDate: state.selectedDate,
                onDateSelected: (date) => context.read<SportsBloc>().add(LoadMatchesByDate(date)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text('Live events', style: AppTypography.h3),
              ),
              ...state.liveMatches.map((m) => MatchCard(match: m, isLive: true)).toList(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Pre-match events', style: AppTypography.h3),
              ),
              ...state.scheduledMatches.map((m) => MatchCard(match: m)).toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyGamesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('My Games'));
  }
}

class _StatisticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Statistics'));
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
    return false;
  }
}
