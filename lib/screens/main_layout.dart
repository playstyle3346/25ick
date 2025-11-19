import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'post_screen.dart';
import 'discussion_list_screen.dart';
import 'myscene_screen.dart';
import 'mypage_screen.dart';
import 'community_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PostScreen(),
    CommunityScreen(),
    MySceneScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: '포스트'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: '마이씬'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
        ],
      ),
    );
  }
}
