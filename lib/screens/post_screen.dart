import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/post_card.dart';
import 'post_write_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);

    // ✨ AppState가 변경되면(좋아요/팔로우 등) 화면을 다시 그려서 정렬/필터링 갱신
    AppState().addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChanged);
    _tab.dispose();
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  // ✨ 정렬 및 필터링 로직
  List _filterPosts(int index) {
    // 원본 리스트 복사 (sort는 원본을 바꾸므로 복사본 사용 필수)
    final posts = List.from(AppState().posts);

    if (index == 0) {
      // 최신순 (생성일 내림차순)
      return posts..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    if (index == 1) {
      // 인기순 (좋아요 내림차순, 같으면 최신순)
      return posts..sort((a, b) {
        int compare = b.likes.compareTo(a.likes);
        return compare == 0 ? b.createdAt.compareTo(a.createdAt) : compare;
      });
    }
    if (index == 2) {
      // 팔로우 (내가 팔로우한 사람의 글만)
      return posts.where((p) => p.isFollowed).toList();
    }
    return posts;
  }

  void _openWriteScreen() async {
    final newPost = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PostWriteScreen()));

    if (newPost != null) {
      // AppState에 추가 로직이 있다면 거기서 처리됨.
      // 여기서는 화면 갱신만
      setState(() {});
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
          controller: _tab,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "최신순"),
            Tab(text: "인기순"),
            Tab(text: "팔로우"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _openWriteScreen,
        child: const Icon(Icons.edit, color: Colors.black),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildList(0),
          _buildList(1),
          _buildList(2),
        ],
      ),
    );
  }

  Widget _buildList(int index) {
    final posts = _filterPosts(index);

    if (posts.isEmpty) {
      return const Center(
        child: Text("게시물이 없습니다.", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: posts.length,
      itemBuilder: (_, i) => PostCard(post: posts[i]),
    );
  }
}