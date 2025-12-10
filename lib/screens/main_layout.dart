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

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    /// 앱 첫 실행 시 DummyRepository → AppState.posts로 복사
    if (AppState().posts.isEmpty) {
      AppState().posts = List.from(DummyRepository.posts);
    }
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
