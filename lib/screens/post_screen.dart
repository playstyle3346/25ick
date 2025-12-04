import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/models.dart';
import '../../data/dummy_repository.dart';
import '../../widgets/post_card.dart';
import 'post_write_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 게시물 데이터를 로컬 상태로 관리
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _posts = List.from(DummyRepository.posts);
  }

  // 글쓰기 화면 이동
  void _navigateToWriteScreen() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const PostWriteScreen()),
    );

    if (newPost != null) {
      setState(() {
        _posts.insert(0, newPost);
      });
    }
  }

  // 탭에 따라 정렬된 리스트 반환
  List<Post> _getSortedPosts(int tabIndex) {
    List<Post> sortedList = List.from(_posts);

    switch (tabIndex) {
      case 0: // 최신순
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return sortedList;
      case 1: // 인기순 (좋아요 많은 순)
      // 좋아요 숫자가 같으면 최신순으로 2차 정렬 (더 자연스러운 UX를 위해)
        sortedList.sort((a, b) {
          int compare = b.likes.compareTo(a.likes);
          if (compare == 0) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return compare;
        });
        return sortedList;
      case 2: // 팔로우
        return sortedList.where((p) => p.isFollowed).toList();
      default:
        return sortedList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("포스트",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "최신순"),
            Tab(text: "인기순"),
            Tab(text: "팔로우"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(_getSortedPosts(0)),
          _buildPostList(_getSortedPosts(1)),
          _buildPostList(_getSortedPosts(2)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToWriteScreen,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.black),
      ),
    );
  }

  Widget _buildPostList(List<Post> postList) {
    if (postList.isEmpty) {
      return const Center(
        child: Text("게시물이 없습니다.", style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: postList[index],
          // ✨ [핵심 수정] 카드의 좋아요 상태가 변하면 화면을 다시 그려서 정렬 갱신!
          onLikeChanged: () {
            setState(() {
              // 화면을 다시 그리면 _getSortedPosts가 다시 실행되어 순서가 바뀜
            });
          },
        );
      },
    );
  }
}