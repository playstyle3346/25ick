import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../data/dummy_repository.dart';
import '../post_detail_screen.dart';
import '../../models/models.dart'; // ✅ Comment, Post 클래스 불러오기

class MyCommentsScreen extends StatelessWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final posts = appState.posts;

    // ✅ 명확한 타입 지정 (Map<String, dynamic> → Map<String, Object>)
    final myComments = posts
        .expand((p) => p.comments.map((c) => {'comment': c, 'post': p}))
        .where((pair) {
      final comment = pair['comment'] as Comment;
      return comment.username == DummyRepository.myName;
    })
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "내가 쓴 댓글",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: myComments.isEmpty
          ? const Center(
        child: Text(
          "작성한 댓글이 없습니다.",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      )
          : ListView.builder(
        itemCount: myComments.length,
        itemBuilder: (context, index) {
          // ✅ 타입 캐스팅 확실히
          final Comment c = myComments[index]['comment'] as Comment;
          final Post p = myComments[index]['post'] as Post;

          // ✅ avatarUrl null-safe 처리
          final avatarPath = (c.avatarUrl != null &&
              c.avatarUrl!.isNotEmpty)
              ? c.avatarUrl!
              : 'assets/posters/insideout.jpg';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(post: p),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.username,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.text,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "→ ${p.title}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
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
