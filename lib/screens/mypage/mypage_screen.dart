import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_colors.dart';
import 'settings_screen.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../mypage/my_posts_screen.dart';
import '../mypage/my_comments_screen.dart';
import '../mypage/my_followers_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? userData;

  // 📸 날짜별 이미지 저장 (Web 대응: Uint8List 사용)
  final Map<String, Uint8List> _dateImages = {};

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
          // 🔹 프로필
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

          // 🔹 통계 박스
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBox("내가 쓴 포스트", postCount.toString(), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MyPostsScreen()));
              }),
              _statBox("작성한 댓글", commentCount.toString(), () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const MyCommentsScreen()));
              }),
              _statBox("팔로워", followerCount.toString(), () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const MyFollowersScreen()));
              }),
            ],
          ),

          const SizedBox(height: 30),

          // 🔹 캘린더
          _buildCalendar(),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // ✅ 전체 화면 이미지 확대 보기 기능
  // -----------------------------------------------------
  void _showFullImage(Uint8List bytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Scaffold(
              backgroundColor: Colors.black,
              body: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.memory(bytes),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  // -----------------------------------------------------
  // 🔸 캘린더 UI
  // -----------------------------------------------------
  Widget _buildCalendar() {
    int currentYear = DateTime
        .now()
        .year;
    int currentMonth = DateTime
        .now()
        .month;

    return StatefulBuilder(builder: (context, setState) {
      final months = List.generate(12, (i) => i + 1);
      final years = List.generate(6, (i) =>
      DateTime
          .now()
          .year - i);

      DateTime firstDay = DateTime(currentYear, currentMonth, 1);
      int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
      int firstWeekday = firstDay.weekday % 7;

      List<int?> calendarDays = List.generate(
        firstWeekday + daysInMonth,
            (index) => index < firstWeekday ? null : index - firstWeekday + 1,
      );

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // 🔸 년/월 선택
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

            // 🔸 요일 헤더
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

            // 🔸 날짜 + 이미지
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: calendarDays.length,
              itemBuilder: (context, index) {
                final day = calendarDays[index];
                if (day == null) return const SizedBox.shrink();

                final dateKey = "$currentYear-$currentMonth-$day";
                final bytes = _dateImages[dateKey];

                return GestureDetector(
                  onTap: () async {
                    if (bytes != null) {
                      // 🖼 사진 확대 보기
                      _showFullImage(bytes);
                      return;
                    }

                    // 사진 업로드
                    final picker = ImagePicker();
                    final picked =
                    await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      final uploadedBytes = await picked.readAsBytes();
                      setState(() => _dateImages[dateKey] = uploadedBytes);
                    }
                  },
                  onLongPress: () async {
                    if (bytes == null) return;

                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            backgroundColor: AppColors.card,
                            title: const Text("사진 삭제",
                                style: TextStyle(color: AppColors.textPrimary)),
                            content: const Text("사진을 삭제하시겠습니까?",
                                style: TextStyle(
                                    color: AppColors.textSecondary)),
                            actions: [
                              TextButton(
                                child: const Text("취소",
                                    style: TextStyle(color: Colors.grey)),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: const Text("삭제",
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                    );

                    if (shouldDelete == true) {
                      setState(() => _dateImages.remove(dateKey));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: bytes != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                        : Center(
                      child: Text(
                        "$day",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // -----------------------------------------------------
  // 통계 박스
  // -----------------------------------------------------
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 숫자(count) 제거됨!

            // 텍스트(라벨)는 그대로 유지
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
