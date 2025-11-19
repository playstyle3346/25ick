import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TalkieApp());
}

class TalkieApp extends StatelessWidget {
  const TalkieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talkie',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      home: const SplashScreen(),
    );
  }
}
