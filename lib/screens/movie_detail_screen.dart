import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('영화 상세정보'),
        actions: const [
          Icon(Icons.share, color: AppColors.textPrimary),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 포스터 & 상단 정보
            Stack(
              children: [
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    image: const DecorationImage(
                      image: AssetImage('assets/placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[700],
                      image: const DecorationImage(
                        image: AssetImage('assets/placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 160,
                  bottom: 40,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '애프터썬',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '2023년 · 드라마/가족 · 96분 · 4.5⭐',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 기본정보
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "기본정보",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "이곳은 영화 줄거리나 간단한 시놉시스가 들어갈 공간입니다. "
                    "실제 API 연동 시 영화 설명으로 대체됩니다.",
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 출연/제작진
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "출연/제작진",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "배우 ${index + 1}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 영화 속 명대사
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "영화 속 명대사",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "\"우리가 잃어버린 것들 속엔, 여전히 사랑이 남아있다.\"",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 명장면
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "명장면",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(
                3,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "명장면 이미지 ${index + 1}",
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 갤러리
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "갤러리",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "사진 ${index + 1}",
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 비슷한 영화
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "비슷한 영화",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.movie, color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "비슷한 영화 ${index + 1}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
