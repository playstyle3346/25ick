import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MySceneScreen extends StatelessWidget {
  const MySceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          "마이씬 화면 (내가 본 영화, 감상기록)",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
