import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

import 'discussion/discussion_list_screen.dart';
import 'preference/movie_preference_start_screen.dart';
import 'poster/poster_make_screen.dart';


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("커뮤니티 입장"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _menuButton(
              title: "토론방",
              subtitle: "하루종일 이야기 나눠보자!",
              color: const Color(0xFFFFCF8F),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscussionListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✔ 취향저격 페이지 연결
            _menuButton(
              title: "취향저격 영화 찾기",
              subtitle: "오늘은 무슨 영화 볼까?",
              color: const Color(0xFFFFE08A),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoviePreferenceStartScreen(),
                ),
              ),
            ),

            const SizedBox(height: 16),
            _menuButton(
              title: "포스터 만들기",
              subtitle: "나만의 jpg 만들어 가기",
              color: const Color(0xFFCBFFA9),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PosterMakeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 텍스트 검정
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            /// 아이콘 검정
            const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
