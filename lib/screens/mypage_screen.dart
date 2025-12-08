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

    /// 🔥 AppState의 변화가 생기면 자동으로 MyPageScreen이 새로 그려지도록 한다.
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    final int postCount = appState.myPostCount;
    final int commentCount = appState.myCommentCount;
    final int followerCount = appState.myFollowerCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('마이페이지'),
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
          // 프로필 UI
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?['nickname'] ?? "",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    userData?['email'] ?? "",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 카운트 UI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBox("내가 쓴 포스트", postCount.toString()),
              _statBox("작성한 댓글", commentCount.toString()),
              _statBox("팔로워", followerCount.toString()),
            ],
          ),

          const SizedBox(height: 30),

          // 취향 찾기 UI
          _preferenceBox(),

          const SizedBox(height: 30),

          // 캘린더 UI
          _buildCalendar(),
        ],
      ),
    );
  }

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
                  onPressed: () {},
                  child: const Text("나의 취향 확인하기"),
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
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
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
