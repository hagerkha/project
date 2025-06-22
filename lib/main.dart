import 'package:authenticationapp/pages_home/daily_habit/data/data_sources/habits_data_source.dart';
import 'package:authenticationapp/pages_home/daily_habit/data/repository/habits_repository.dart';
import 'package:authenticationapp/pages_home/daily_habit/presentation/logic/habits_view_model.dart';
import 'package:authenticationapp/pages_home/daily_habit/presentation/screens/daily_habits_screen.dart';
import 'package:authenticationapp/pages_home/interactive/contact_game/contact_arabic.dart';
import 'package:authenticationapp/pages_home/interactive/data/data_sources/interactive_data_source.dart';
import 'package:authenticationapp/pages_home/interactive/data/repository/interactive_repository.dart';
import 'package:authenticationapp/pages_home/interactive/presentation/New%20folder/arabic_game.dart';
import 'package:authenticationapp/pages_home/interactive/presentation/New%20folder/color_intro_screen.dart';
import 'package:authenticationapp/pages_home/interactive/presentation/New%20folder/main_interactive_screen.dart';
import 'package:authenticationapp/pages_home/interactive/presentation/New%20folder/math_sports_screen.dart';
import 'package:authenticationapp/pages_home/interactive/presentation/logic/interactive_view_model.dart';
import 'package:authenticationapp/pages_home/social_situations/data/data_sources/social_situations_data_source.dart';
import 'package:authenticationapp/pages_home/social_situations/data/repository/social_situations_repository.dart';
import 'package:authenticationapp/pages_home/social_situations/presentation/logic/social_situations_view_model.dart';
import 'package:authenticationapp/pages_home/social_situations/presentation/screens/feelings_intro_screen.dart';
import 'package:authenticationapp/service/data/data_source/auth_data_source.dart';
import 'package:authenticationapp/service/data/repository/auth_repository.dart';
import 'package:authenticationapp/service/presentaion/logic/auth_view_model.dart';
import 'package:authenticationapp/service/presentaion/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthDataSource>(create: (_) => AuthDataSource()),
        Provider<AuthRepository>(create: (context) => AuthRepository(context.read<AuthDataSource>())),
        ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel(context.read<AuthRepository>())),
        Provider<HabitsDataSource>(create: (_) => HabitsDataSource()),
        Provider<HabitsRepository>(create: (context) => HabitsRepository(context.read<HabitsDataSource>())),
        ChangeNotifierProvider<HabitsViewModel>(create: (context) => HabitsViewModel(context.read<HabitsRepository>())),
        Provider<InteractiveDataSource>(create: (_) => InteractiveDataSource()),
        Provider<InteractiveRepository>(create: (context) => InteractiveRepository(context.read<InteractiveDataSource>())),
        ChangeNotifierProvider<InteractiveViewModel>(create: (context) => InteractiveViewModel(context.read<InteractiveRepository>())),
        Provider<SocialSituationsDataSource>(create: (_) => SocialSituationsDataSource()),
        Provider<SocialSituationsRepository>(create: (context) => SocialSituationsRepository(context.read<SocialSituationsDataSource>())),
        ChangeNotifierProvider<SocialSituationsViewModel>(create: (context) => SocialSituationsViewModel(context.read<SocialSituationsRepository>())),
      ],
      child: MaterialApp(
        title: 'Daily Habits App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/daily_habits': (context) => const DailyHabitsScreen(),
          '/interactive_learning': (context) => const MainInteractiveScreen(),
          '/color_intro': (context) => const ColorIntroScreen(),
          '/math_sports': (context) => const MathSportsScreen(),
          '/arabic_game': (context) => const ArabicGameScreen(),
          '/english_game': (context) => const ArabicGameScreen(),
          '/animal_game': (context) => const ArabicGameScreen(),
          '/help_game': (context) => const ArabicGameScreen(),
          '/plus_game': (context) => const ArabicGameScreen(),
          '/minus_game': (context) => const ArabicGameScreen(),
          '/counting_game': (context) => const ArabicGameScreen(),
          '/arabic_content': (context) => const ContactArabicPage(),
          '/english_content': (context) => const ContactArabicPage(),
          '/social_situations': (context) => const ContactArabicPage(),
          '/feelings_intro': (context) => const FeelingsIntroScreen(),
        },
      ),
    );
  }
}