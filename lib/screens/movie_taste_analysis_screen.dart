import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'movie_tag_recommendation.dart';

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

            const SizedBox(height: 24),

            // 버블 이미지 4~5개
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _bubble("assets/placeholder.jpg", 110, 0, 0),
                  _bubble("assets/placeholder.jpg", 70, -120, 10),
                  _bubble("assets/placeholder.jpg", 60, 90, -20),
                  _bubble("assets/placeholder.jpg", 70, -60, 70),
                ],
              ),
            ),

            const SizedBox(height: 30),

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

            _button(
              label: "다음",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MovieTagRecommendationScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _button({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.primary)),
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.primary)),
    );
  }

  Widget _tagLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.black, fontSize: 15)),
    );
  }

  Widget _bubble(String img, double size, double x, double y) {
    return Positioned(
      left: x + 150,
      top: y + 80,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
