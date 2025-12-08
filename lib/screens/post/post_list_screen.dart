import 'package:flutter/material.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostService _postService = PostService();
  List posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _postService.fetchPosts();
    setState(() {
      posts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("커뮤니티"),
        backgroundColor: AppColors.background,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final p = posts[index];
          return ListTile(
            title: Text(p["title"]),
            subtitle: Text(p["content"]),
          );
        },
      ),
    );
  }
}
