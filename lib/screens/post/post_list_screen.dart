import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/dummy_repository.dart';
import '../../widgets/post_card.dart';
import '../../models/models.dart';
import '../post_write_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {

  /// 정렬 없이 그대로 리스트 반환
  List<Post> _getPosts() {
    return List<Post>.from(DummyRepository.posts);
  }

  /// 글쓰기 화면 열기 → 작성 후 돌아오면 갱신
  void _openWriteScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostWriteScreen()),
    );

    if (result == true) setState(() {});
  }

  /// PostCard에서 삭제/좋아요 시 호출되는 새로고침
  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
      itemBuilder: (context, i) {
        return PostCard(
          post: posts[i],
          onContentChanged: _refreshList,
        );
      },
    );
  }
}
