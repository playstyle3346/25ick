import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/movie_algorithm.dart';
import '../../main_layout.dart'; // ← 추가!
import 'movie_taste_analysis_screen.dart';

class MoviePreferenceResultScreen extends StatelessWidget {
  const MoviePreferenceResultScreen({super.key});

  void _goToCommunity(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainLayout(initialIndex: 2), // ← 하단바 포함된 커뮤니티
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userType = MovieAlgorithm.lastUserType;
    final recommendations = MovieAlgorithm.lastRecommendations;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _goToCommunity(context),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "취향에 딱 맞는 영화를 찾았어요!",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              userType.isNotEmpty
                  ? "당신은 '$userType' 유형이에요."
                  : "당신의 영화 취향을 분석했어요.",
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            _posterCard(recommendations),

            const SizedBox(height: 24),

            if (recommendations.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recommendations
                    .map(
                      (title) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "· $title",
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roundButton(label: "다시 시작", onTap: () => Navigator.pop(context)),
                _roundButton(
                  label: "분석 결과",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MovieTasteAnalysisScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterCard(List<String> recommendations) {
    final mainTitle =
    recommendations.isNotEmpty ? recommendations.first : "라라랜드";
    final posterPath = MovieAlgorithm.posterPaths[mainTitle];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "<$mainTitle>",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              posterPath ?? "assets/placeholder.jpg",
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.primary)),
      ),
    );
  }
}
