import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart' as di;
import 'features/sports/presentation/bloc/sports_bloc.dart';
import 'features/sports/presentation/pages/sports_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SportsBloc>()..add(LoadLiveMatches()),
      child: MaterialApp(
        title: 'Sports UI Reconstruction',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SportsPage(),
      ),
    );
  }
}
