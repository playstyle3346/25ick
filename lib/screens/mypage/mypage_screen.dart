import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../settings_screen.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';

// ✅ 클릭 시 이동할 상세 페이지 import
import 'my_posts_screen.dart';
import 'my_comments_screen.dart';
import 'my_followers_screen.dart';

// ✅ 취향저격 영화 찾기 페이지 import (경로 맞게 확인 필요)
import '../community/preference/movie_preference_start_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUser();
    AppState().addListener(_onAppStateChange);
  }

  void _onAppStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChange);
    super.dispose();
  }

  Future<void> _loadUser() async {
    userData = await _auth.getUserData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title:
        const Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
              },
              child: const Icon(Icons.settings, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      body: userData == null
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : _buildMainContent(appState),
    );
  }

  Widget _buildMainContent(AppState appState) {
    final int postCount = appState.myPostCount;
    final int commentCount = appState.myCommentCount;
    final int followerCount = appState.myFollowerCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1️⃣ 프로필
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[700],
                  image: const DecorationImage(
                    image: AssetImage("assets/posters/insideout.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?['nickname'] ?? "Jäger",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    userData?['email'] ?? "영화 씹어먹는 이동진 꿈나무",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2️⃣ 통계 (포스트, 댓글, 팔로워)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBox("내가 쓴 포스트", postCount.toString(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyPostsScreen()),
                );
              }),
              _statBox("작성한 댓글", commentCount.toString(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyCommentsScreen()),
                );
              }),
              _statBox("팔로워", followerCount.toString(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyFollowersScreen()),
                );
              }),
            ],
          ),

          const SizedBox(height: 30),

          // 3️⃣ 취향 찾기
          _preferenceBox(context),

          const SizedBox(height: 30),

          // 4️⃣ 캘린더
          _buildCalendar(),
        ],
      ),
    );
  }

  // ✅ 취향 찾기 박스
  Widget _preferenceBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "취향 찾기",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
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
                    image: AssetImage("assets/posters/lalaland.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.movie_filter,
                      color: Colors.white.withOpacity(0.5), size: 40),
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
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MoviePreferenceStartScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "나의 취향 확인하기",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ 캘린더 (년도/월별 실제 날짜 표시)
  Widget _buildCalendar() {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;

    return StatefulBuilder(
      builder: (context, setState) {
        final months = List.generate(12, (i) => i + 1);
        final years = List.generate(6, (i) => DateTime.now().year - i);

        DateTime firstDay = DateTime(currentYear, currentMonth, 1);
        int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
        int firstWeekday = firstDay.weekday % 7;

        List<int?> calendarDays = List.generate(
          firstWeekday + daysInMonth,
              (index) =>
          index < firstWeekday ? null : index - firstWeekday + 1,
        );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 년/월 선택 드롭다운
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: currentYear,
                    dropdownColor: AppColors.card,
                    iconEnabledColor: AppColors.textPrimary,
                    style: const TextStyle(color: AppColors.textPrimary),
                    underline: const SizedBox(),
                    items: years
                        .map((y) =>
                        DropdownMenuItem(value: y, child: Text("$y년")))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => currentYear = v);
                    },
                  ),
                  DropdownButton<int>(
                    value: currentMonth,
                    dropdownColor: AppColors.card,
                    iconEnabledColor: AppColors.textPrimary,
                    style: const TextStyle(color: AppColors.textPrimary),
                    underline: const SizedBox(),
                    items: months
                        .map((m) =>
                        DropdownMenuItem(value: m, child: Text("$m월")))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => currentMonth = v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              // 날짜 표시
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 0.9),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  final day = calendarDays[index];
                  bool hasRecord = [5, 12, 25].contains(day);

                  if (day == null) return const SizedBox.shrink();

                  return Container(
                    decoration: BoxDecoration(
                      color: hasRecord
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.grey[850],
                      borderRadius: BorderRadius.circular(6),
                      border:
                      hasRecord ? Border.all(color: AppColors.primary) : null,
                    ),
                    child: Center(
                      child: Text(
                        "$day",
                        style: TextStyle(
                          color: hasRecord
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: hasRecord
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ 통계 박스 (클릭 가능)
  Widget _statBox(String title, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
