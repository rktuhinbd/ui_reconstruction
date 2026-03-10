import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/sports_bloc.dart';
import '../widgets/common_widgets.dart';
import '../widgets/schedule_tab.dart';
import '../widgets/my_games_widgets.dart';
import '../widgets/statistics_widgets.dart';

/// The main dashboard page for sports information.
/// 
/// Realizes a collapsing toolbar effect with parallax background and 
/// a tabbed view for "Schedule", "My games", and "Statistics".
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
    if (_scrollController.hasClients &&
        _scrollController.offset > (220 - kToolbarHeight)) {
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
    super.dispose();
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
            final iconColor = _isAppBarCollapsed
                ? AppColors.primaryBlue
                : Colors.white;
            final appBarColor = _isAppBarCollapsed
                ? Colors.white
                : Colors.transparent;

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
                                    colors: [
                                      Color(0xFF0F172A),
                                      Color(0xFF334155),
                                    ],
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
                      delegate: SliverAppBarDelegate(
                        Container(
                          color: AppColors.scaffoldBackground,
                          child: Column(
                            children: [
                              Container(
                                height: 42,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TabBar(
                                  onTap: (index) => context
                                      .read<SportsBloc>()
                                      .add(ChangeTab(index)),
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
                    ScheduleTab(state: state),
                    MyGamesTab(state: state),
                    StatisticsTab(state: state),
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
