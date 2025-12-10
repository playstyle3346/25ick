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

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    AppState().addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  // ✨ 단일 리스트만 출력 — 최신순 정렬만 유지(원하는 정렬 유지 가능)
  List _getPosts() {
    final posts = List.from(AppState().posts);
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  void _openWriteScreen() async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostWriteScreen()),
    );

    if (newPost != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "포스트",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _openWriteScreen,
        child: const Icon(Icons.edit, color: Colors.black),
      ),

      body: _buildList(),
    );
  }

  Widget _buildList() {
    final posts = _getPosts();

    if (posts.isEmpty) {
      return const Center(
        child: Text(
          "게시물이 없습니다.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: posts.length,
      itemBuilder: (_, i) => PostCard(post: posts[i]),
    );
  }
}
