import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'movie_taste_analysis_screen.dart';

class MovieDetailInfoScreen extends StatelessWidget {
  final String movieTitle;

  const MovieDetailInfoScreen({super.key, required this.movieTitle});

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.close, color: Colors.white),
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
            const SizedBox(height: 24),

            // 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "영화 정보",
                    style: TextStyle(color: AppColors.primary, fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _actor("라이언 고슬링"),
                      _actor("해리슨 포드"),
                      _actor("아나 디 아르마스"),
                      _actor("자레드 레토"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("상영시간: 164분",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),

                  _runtimeBar(164),

                  const SizedBox(height: 10),
                  const Text("평균보다 40분 더 길어요!",
                      style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _nextButton(
              label: "다음",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MovieTasteAnalysisScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _nextButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary, width: 1.2),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.primary)),
      ),
    );
  }
}

class _actor extends StatelessWidget {
  final String name;

  const _actor(this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(radius: 23, backgroundColor: Colors.grey),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}

Widget _runtimeBar(int runtime) {
  return Container(
    height: 8,
    decoration: BoxDecoration(
      color: Colors.grey[700],
      borderRadius: BorderRadius.circular(4),
    ),
    child: FractionallySizedBox(
      widthFactor: runtime / 200,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}
