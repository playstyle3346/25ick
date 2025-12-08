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
  }

  List _filterPosts(int index) {
    final posts = AppState().posts;

    if (index == 0) {
      return posts..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    if (index == 1) {
      return posts..sort((a, b) => b.likes.compareTo(a.likes));
    }
    if (index == 2) {
      return posts.where((p) => p.isFollowed).toList();
    }
    return posts;
  }

  void _openWriteScreen() async {
    final newPost = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PostWriteScreen()));

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
        title: const Text("포스트",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
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
