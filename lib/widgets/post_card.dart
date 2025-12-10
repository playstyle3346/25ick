import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../screens/post_detail_screen.dart';
import '../data/dummy_repository.dart';

class PostCard extends StatefulWidget {
  final Post post;

  /// 삭제/팔로우/좋아요 후 상위 리스트 업데이트용
  final VoidCallback? onContentChanged;

  const PostCard({
    super.key,
    required this.post,
    this.onContentChanged,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // 이미지 로드 (assets / file / memory 지원)
  Widget _buildImage(Post post) {
    if (post.imageBytes != null) {
      return Image.memory(
        post.imageBytes!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }

    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      if (post.imageUrl!.startsWith("assets/")) {
        return Image.asset(
          post.imageUrl!,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      }
      return Image.file(
        File(post.imageUrl!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox.shrink();
  }

  /// 삭제 기능
  void _deletePost() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("포스트 삭제", style: TextStyle(color: Colors.white)),
        content: const Text("정말 삭제하시겠습니까?",
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              DummyRepository.deletePost(widget.post);
              Navigator.pop(ctx);

              if (widget.onContentChanged != null) widget.onContentChanged!();
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isMyPost = post.username == DummyRepository.myName;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailScreen(post: post),
          ),
        );

        if (widget.onContentChanged != null) widget.onContentChanged!();
        setState(() {});
      },
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
            // ------------------------------
            //   상단: 프로필 + 작성자 정보
            // ------------------------------
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.userAvatarUrl),
                  radius: 18,
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.username,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold)),
                      const Text("방금 전",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),

                // 삭제 or 팔로우 버튼
                isMyPost
                    ? IconButton(
                  onPressed: _deletePost,
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.grey, size: 20),
                )
                    : GestureDetector(
                  onTap: () {
                    setState(() => post.toggleFollow());
                    if (widget.onContentChanged != null)
                      widget.onContentChanged!();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: post.isFollowed
                          ? Colors.grey[800]
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.isFollowed ? "언팔로우" : "팔로우",
                      style: TextStyle(
                        color: post.isFollowed
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 제목
            Text(
              post.title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            // 본문
            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14),
            ),

            const SizedBox(height: 10),

            // 이미지 영역
            if (post.imageBytes != null ||
                (post.imageUrl != null && post.imageUrl!.isNotEmpty))
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImage(post),
              ),

            const SizedBox(height: 10),

            // ------------------------------
            //  좋아요 / 싫어요 / 댓글 갯수
            // ------------------------------
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color:
                    post.isLiked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => post.toggleLike());
                    if (widget.onContentChanged != null)
                      widget.onContentChanged!();
                  },
                ),
                Text("${post.likes}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                IconButton(
                  icon: Icon(
                    post.isDisliked
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                    color:
                    post.isDisliked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => post.toggleDislike());
                    if (widget.onContentChanged != null)
                      widget.onContentChanged!();
                  },
                ),
                Text("${post.dislikes}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${post.comments.length}",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
