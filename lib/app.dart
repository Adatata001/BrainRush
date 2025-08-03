import 'package:flutter/material.dart';
import 'package:brainrush/screens/loading.dart';
import 'package:brainrush/screens/home.dart';
import 'package:brainrush/screens/category_selection.dart';
import 'package:brainrush/screens/settings.dart';
import 'package:brainrush/screens/level.dart';
import 'package:brainrush/screens/game.dart';
import 'package:brainrush/screens/game_over.dart';
import 'package:brainrush/screens/level_complete.dart';
import 'package:google_fonts/google_fonts.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainRush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF90E0EF),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/home': (context) => const HomeScreen(),
        '/category': (context) => const CategoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/level': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LevelScreen(
            category: args['category'],
            totalLevels: args['totalLevels'],
            unlockedLevel: args['unlockedLevel'],
            levelColor: args['levelColor'],
          );
        },
        '/game': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GameScreen(
            category: args['category'],
            level: args['level'],
            levelColor: args['levelColor'],
            initialPoints: args['initialPoints'] ?? 0,
          );
        },
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/gameover':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => GameOverScreen(
                category: args['category'],
                level: args['level'],
                unlockedLevel: args['unlockedLevel'],
                levelColor: args['levelColor'],
                points: args['points'],
              ),
            );

          case '/levelcomplete':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => LevelCompleteScreen(
                points: args['points'],
                levelNumber: args['levelNumber'],
                category: args['category'],
                totalPoints: args['totalPoints'],
                levelColor: args['levelColor'],
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}