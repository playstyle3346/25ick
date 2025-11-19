import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('마이페이지'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 프로필 영역
            Row(
              children: [
                // 프로필 이미지
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[700],
                    image: const DecorationImage(
                      image: AssetImage('assets/placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 닉네임 + 설명
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "시애틀고양이",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "영화덕후 3년차",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔹 통계 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("내가 쓴 포스트", "5"),
                _statBox("작성한 댓글", "67"),
                _statBox("팔로워", "2"),
              ],
            ),

            const SizedBox(height: 28),

            // 🔹 취향 찾기 영역
            const Text(
              "취향 찾기",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "\"당신의 취향에 맞는 영화를 찾아드릴게요.\"",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("나의 취향 확인하기"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 🔹 캘린더 영역 (월별 감상기록)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "캘린더",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "2025년 6월",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 요일 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("일", style: TextStyle(color: AppColors.textSecondary)),
                      Text("월", style: TextStyle(color: AppColors.textSecondary)),
                      Text("화", style: TextStyle(color: AppColors.textSecondary)),
                      Text("수", style: TextStyle(color: AppColors.textSecondary)),
                      Text("목", style: TextStyle(color: AppColors.textSecondary)),
                      Text("금", style: TextStyle(color: AppColors.textSecondary)),
                      Text("토", style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 간단한 날짜 + 포스터 썸네일
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: index % 6 == 0
                            ? Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/placeholder.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )
                            : Center(
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────
  // 📊 통계 박스 위젯
  // ───────────────────────────────
  Widget _statBox(String title, String count) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
