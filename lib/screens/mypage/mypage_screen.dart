import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'settings_screen.dart';
import '../services/auth_service.dart';
import '../state/app_state.dart';

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

    // ✨ [핵심] 다른 화면에서 팔로우를 하고 돌아왔을 때 숫자를 갱신하기 위한 리스너
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
    // AppState 가져오기
    final appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold)),
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

    // ✨ [수정됨] 내가 팔로우한 사람의 수(isFollowed가 true인 포스트 작성자 수)를 실시간으로 계산
    final int followerCount = appState.posts.where((p) => p.isFollowed).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 프로필 UI
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[700],
                  image: const DecorationImage(
                    // 임시 프로필 이미지
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

          // 2. 카운트 UI (포스트, 댓글, 팔로워)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBox("내가 쓴 포스트", postCount.toString()),
              _statBox("작성한 댓글", commentCount.toString()),
              // ✨ 여기서 계산된 followerCount를 보여줌
              _statBox("팔로워", followerCount.toString()),
            ],
          ),

          const SizedBox(height: 30),

          // 3. 취향 찾기 UI (기존 코드 유지)
          _preferenceBox(),

          const SizedBox(height: 30),

          // 4. 캘린더 UI (기존 코드 유지)
          _buildCalendar(),
        ],
      ),
    );
  }

  // --- 기존 UI 위젯들 유지 ---

  Widget _preferenceBox() {
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
                  // 예시 이미지 (없으면 제거 가능)
                  image: const DecorationImage(
                    image: AssetImage("assets/posters/lalaland.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.movie_filter, color: Colors.white.withOpacity(0.5), size: 40),
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
                    // 취향 찾기 페이지 이동 로직
                  },
                  child: const Text("나의 취향 확인하기", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
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
              // 임시로 5, 12, 25일에 기록이 있다고 가정
              bool hasRecord = [5, 12, 25].contains(index + 1);
              return Container(
                decoration: BoxDecoration(
                  color: hasRecord ? AppColors.primary.withOpacity(0.2) : Colors.grey[850],
                  borderRadius: BorderRadius.circular(6),
                  border: hasRecord ? Border.all(color: AppColors.primary) : null,
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                        color: hasRecord ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: hasRecord ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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