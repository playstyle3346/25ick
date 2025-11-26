import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'auth/login_screen.dart';
import '../services/auth_service.dart'; // 나중에 서버 로그인 시 쓸 수 있도록

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) {
    AuthService.logout(); // 지금은 단순히 상태 리셋
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // 이전 화면 모두 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "설정",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text(
                "로그아웃",
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () => _logout(context),
            ),
            const Divider(color: Colors.white12),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "앱 버전 1.0.0",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
