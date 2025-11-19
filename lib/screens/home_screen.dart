import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/section_title.dart';
import '../widgets/movie_card.dart';
import '../widgets/genre_chip.dart';
import 'movie_detail_screen.dart'; // ✅ 추가

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("안녕하세요, 시네프렌양님"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 대표 배너
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text("메인 영화 배너", style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 24),

            const SectionTitle(title: "실시간 HOT 인기작"),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => MovieCard(
                  title: "영화 ${index + 1}",
                  onTap: () {
                    // ✅ 영화 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MovieDetailScreen()),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: "너의 취향을 찾아봐"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                GenreChip(label: "SF"),
                GenreChip(label: "로맨스"),
                GenreChip(label: "애니메이션"),
                GenreChip(label: "스릴러"),
                GenreChip(label: "액션"),
              ],
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: "최신 TOP"),
            Column(
              children: List.generate(
                3,
                    (index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                        "영화 썸네일 ${index + 1}",
                        style: const TextStyle(color: AppColors.textSecondary),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
