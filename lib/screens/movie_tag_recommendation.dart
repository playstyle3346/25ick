import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MovieTagRecommendationScreen extends StatelessWidget {
  const MovieTagRecommendationScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "시간여행 마니아 ‘시애틀고양이’님\n취향을 분석해 추천드려요!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _movie("인터스텔라"),
                  _movie("백 투 더 퓨처"),
                  _movie("컨택트"),
                  _movie("루퍼"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _movie(String title) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage("assets/placeholder.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
