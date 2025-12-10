import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../screens/post_detail_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Widget _buildImage(String url) {
    if (url.startsWith("assets/")) return Image.asset(url, fit: BoxFit.cover);
    if (File(url).existsSync()) return Image.file(File(url), fit: BoxFit.cover);
    return Image.network(url, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final appState = AppState();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostDetailScreen(post: post),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===========================
            // 유저 정보 + 팔로우 버튼
            // ===========================
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.userAvatarUrl),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.username,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                    const Text("3분 전", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),

                /// ✨ 팔로우 버튼 (토글 기능 & 디자인)
                GestureDetector(
                  onTap: () {
                    appState.toggleFollow(post);
                    // PostScreen은 AppState 리스너를 통해 자동 갱신됨
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // 팔로우 상태면 회색, 아니면 주황색
                      color: post.isFollowed ? Colors.grey[800] : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.isFollowed ? "언팔로우" : "팔로우",
                      style: TextStyle(
                        color: post.isFollowed ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            /// 제목
            Text(post.title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            /// 본문
            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),

            const SizedBox(height: 10),

            /// 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(post.imageUrl),
            ),

            const SizedBox(height: 10),

            // 좋아요/싫어요/댓글 수
            Row(
              children: [
                /// 좋아요
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: post.isLiked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    appState.toggleLike(post);
                    // PostScreen은 AppState 리스너를 통해 자동 갱신되어 인기순 정렬됨
                  },
                ),
                Text("${post.likes}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                /// 싫어요
                IconButton(
                  icon: Icon(
                    post.isDisliked
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                    color: post.isDisliked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    appState.toggleDislike(post);
                  },
                ),
                Text("${post.dislikes}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                /// 댓글 아이콘
                const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${post.comments.length}", style: const TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}