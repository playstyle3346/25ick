// lib/screens/movie_preference_result_screen.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../community_screen.dart';
import '../../../services/movie_algorithm.dart';

/// ===================================================================
/// 1) 영화 취향 결과 화면
/// ===================================================================
class MoviePreferenceResultScreen extends StatelessWidget {
  const MoviePreferenceResultScreen({super.key});

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
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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

            if (recommendations.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "이런 영화들을 추천드려요",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recommendations
                    .map(
                      (title) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "· $title",
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // 버튼 2개
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

  /// 메인 포스터 카드
  Widget _posterCard(List<String> recommendations) {
    final mainTitle =
    recommendations.isNotEmpty ? recommendations.first : "블레이드러너 2049";
    final posterPath = MovieAlgorithm.posterPaths[mainTitle];

    return Container(
      width: double.infinity,
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
                color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  posterPath ?? "assets/placeholder.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 둥근 버튼
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

/// ===================================================================
/// 2) 취향 분석 화면 — 유형별 키워드 완전 반영
/// ===================================================================
class MovieTasteAnalysisScreen extends StatelessWidget {
  const MovieTasteAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = MovieAlgorithm.lastUserType;

    /// 🔥 유형별 키워드 불러오기
    final keywords = MovieAlgorithm.typeKeywords[userType] ?? [];

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
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              userType.isNotEmpty
                  ? "당신의 영화 취향, '$userType' 유형으로 분석되었어요."
                  : "당신의 영화 취향을 분석해 드려요.",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            _tagLabel(userType.isNotEmpty ? userType : "취향 분석 중"),

            const SizedBox(height: 30),

            /// ---------- 유형별 키워드 4개 ----------
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.8,
              children: keywords.map((k) => _TagChip(k)).toList(),
            ),

            const SizedBox(height: 40),

            _nextButton(context),
          ],
        ),
      ),
    );
  }

  /// 완료 버튼
  Widget _nextButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CommunityScreen()),
              (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text("완료", style: TextStyle(color: AppColors.primary)),
      ),
    );
  }

  /// 유형 라벨
  Widget _tagLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}

/// 키워드 칩
class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.primary)),
    );
  }
}

/// ===================================================================
/// 3) (옵션) 최종 추천 Grid 화면
/// ===================================================================
class MovieTagRecommendationScreen extends StatelessWidget {
  const MovieTagRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = MovieAlgorithm.lastUserType;
    final recs = MovieAlgorithm.lastRecommendations;

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
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              userType.isNotEmpty
                  ? "'$userType'님 취향을 분석해 추천드려요!"
                  : "당신의 취향에 맞는 영화를 추천드려요!",
              style: const TextStyle(color: Colors.white, fontSize: 17),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: recs.map((title) => _movie(title)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _movie(String title) {
    final poster = MovieAlgorithm.posterPaths[title];

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              poster ?? "assets/placeholder.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}