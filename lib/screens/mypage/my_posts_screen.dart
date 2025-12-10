import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/app_state.dart';
import '../post_detail_screen.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final myName = appState.posts.isNotEmpty
        ? appState.posts.first.username
        : "나";

    // 내가 쓴 포스트만 필터링
    final myPosts =
    appState.posts.where((p) => p.username == myName).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("내가 쓴 게시물",
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: myPosts.isEmpty
          ? const Center(
        child: Text("아직 작성한 게시물이 없습니다.",
            style: TextStyle(color: AppColors.textSecondary)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: myPosts.length,
        itemBuilder: (context, index) {
          final post = myPosts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(post: post),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up,
                          color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text("${post.likes}",
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.comment,
                          color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text("${post.comments.length}",
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
