import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          "포스트 화면 (추후 내용 추가)",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
