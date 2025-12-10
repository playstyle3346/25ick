import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../data/dummy_repository.dart';

// 화면 import
import 'home/home_screen.dart';
import 'post_screen.dart';
import 'community/community_screen.dart';
import 'my_scene_screen.dart';
import 'mypage/mypage_screen.dart';

// ✅ 추가: 전역 접근을 위해 글로벌 키 선언
final GlobalKey<_MainLayoutState> mainLayoutKey = GlobalKey<_MainLayoutState>();

class MainLayout extends StatefulWidget {
  final int initialIndex; // ← 초기 인덱스 받기

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    // 초기 탭 설정
    _selectedIndex = widget.initialIndex;

    // 앱 첫 실행 시 posts 복사
    if (AppState().posts.isEmpty) {
      AppState().posts = List.from(DummyRepository.posts);
    }
  }

  /// ✅ 하단바 탭 전환 (외부에서 접근 가능하도록 public 메서드로)
  void changeTab(int index) {
    if (index < 0 || index > 4) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const PostScreen(),
      const CommunityScreen(),
      const MySceneScreen(),
      const MyPageScreen(),
    ];

    return Scaffold(
      key: mainLayoutKey,
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "포스트"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "커뮤니티"),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "마이씬"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "마이페이지"),
        ],
      ),
    );
  }
}
