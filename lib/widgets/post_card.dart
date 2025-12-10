import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../screens/post_detail_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        );
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
                    const Text("방금 전",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),

                GestureDetector(
                  onTap: () {
                    setState(() => post.toggleFollow());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
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
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(post.title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),

            const SizedBox(height: 10),

            // 🔥 이미지 렌더링 (Web 전용 Uint8List)
            if (post.imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  post.imageBytes!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),

            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: post.isLiked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => post.toggleLike());
                  },
                ),
                Text("${post.likes}", style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                IconButton(
                  icon: Icon(
                    post.isDisliked
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                    color: post.isDisliked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => post.toggleDislike());
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
            )
          ],
        ),
      ),
    );
  }
}
