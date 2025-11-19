import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'community_screen.dart';

class MoviePreferenceResultScreen extends StatelessWidget {
  final String movieTitle;
  final String posterPath;
  final VoidCallback? onRestart;

  const MoviePreferenceResultScreen({
    super.key,
    this.movieTitle = "블레이드러너 2049",
    this.posterPath = "assets/placeholder.jpg",
    this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        /// 뒤로가기 → VS 화면으로
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        /// X 버튼 → 커뮤니티 입장 화면 이동
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
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "쓸쓸한 속에서도 존재의 의미를 찾고 싶은 당신에게 이 영화를 추천합니다.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),

            _posterCard(),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roundButton(
                  label: "다시 시작",
                  onTap: () {
                    onRestart?.call();
                    Navigator.pop(context);
                  },
                ),
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

  Widget _posterCard() {
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
            "<$movieTitle>",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(posterPath),
                fit: BoxFit.cover,
              ),
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
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary, width: 1.2),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 🔥 취향 분석 화면 (버튼 없이, 오른쪽 X 버튼 추가)
// -------------------------------------------------------------------

class MovieTasteAnalysisScreen extends StatelessWidget {
  const MovieTasteAnalysisScreen({super.key});

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

        /// X 버튼 → 커뮤니티 입장 화면
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
            const Text(
              "당신의 SF 취향, 우주보다 넓게 분석해드립니다.",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _tagLabel("사유하는 디스토피아 러버"),

            const SizedBox(height: 30),

            _bubbleCluster(),

            const SizedBox(height: 40),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _tag("하드 SF 전문가"),
                _tag("시간여행 마니아"),
                _tag("디스토피아 생존자"),
                _tag("SF광"),
                _tag("대중적 명작 큐레이터"),
                _tag("우주 탐험가"),
              ],
            ),

            const SizedBox(height: 40),

            /// 다음 없이 → 영화 추천 태그 화면으로 자동 이동 버튼
            _nextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MovieTagRecommendationScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          "다음",
          style: TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.primary)),
    );
  }

  Widget _tagLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.black, fontSize: 15)),
    );
  }

  Widget _bubbleCluster() {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _bubble(110, 0, 0),
          _bubble(70, -120, -10),
          _bubble(70, 100, 20),
          _bubble(60, -60, 70),
        ],
      ),
    );
  }

  Widget _bubble(double size, double x, double y) {
    return Positioned(
      left: 140 + x,
      top: 80 + y,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
          Border.all(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 🔥 최종 영화 추천 태그 화면
// -------------------------------------------------------------------

class MovieTagRecommendationScreen extends StatelessWidget {
  const MovieTagRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        /// X 버튼 → 커뮤니티 입장
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

      body: Center(
        child: Text(
          "영화 추천 화면 (작성 필요)",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
