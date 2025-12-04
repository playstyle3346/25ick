import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
// import '../data/dummy_repository.dart'; // ✨ 이제 여기서 데이터를 직접 다루지 않으므로 삭제해도 됩니다.

// 화면들 import (파일 경로가 다르다면 수정해주세요)
import 'home_screen.dart';
import 'my_scene_screen.dart';
import 'post_screen.dart';
import 'community_screen.dart';
// ✨ 마이씬 화면이 'myscene' 폴더 안에 있다면 아래 경로, 같은 폴더면 'my_scene_screen.dart'
import 'my_scene_screen.dart';
import 'mypage_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const PostScreen(), // ✨ 인자 없이 호출 (내부에서 데이터 로드)
      const CommunityScreen(),
      const MySceneScreen(), // ✨ 수정됨: 인자 없이 호출 (내부에서 데이터 로드)
      const MyPageScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경색 안전하게 지정
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary, // ✨ 테마 색상 적용
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: '포스트'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: '커뮤니티'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections_outlined),
              activeIcon: Icon(Icons.collections),
              label: '마이씬'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '마이페이지'
          ),
        ],
      ),
    );
  }
}