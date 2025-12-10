import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/auth_service.dart'; // ✅ 닉네임 불러오기용
import 'movie_preference_vs_screen.dart';

class MoviePreferenceStartScreen extends StatefulWidget {
  const MoviePreferenceStartScreen({super.key});

  @override
  State<MoviePreferenceStartScreen> createState() =>
      _MoviePreferenceStartScreenState();
}

class _MoviePreferenceStartScreenState
    extends State<MoviePreferenceStartScreen> {
  String nickname = "영화팬"; // 기본값

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final saved = await AuthService().getSavedNickname();
    if (mounted) {
      setState(() {
        nickname = saved?.isNotEmpty == true ? saved! : "영화팬";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ 닉네임 자동 반영
            Text(
              "$nickname님이 선호하는 \n 영화 장르를 분석해드려요.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MoviePreferenceVsScreen(),
                  ),
                );
              },
              child: const Text(
                "시작하기",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
