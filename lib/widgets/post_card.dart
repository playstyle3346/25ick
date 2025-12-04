import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../screens/post_detail_screen.dart'; // 파일명 주의 (detail_screen.dart 일수도 있음)

class PostCard extends StatefulWidget {
  final Post post;
  // ✨ [추가] 부모에게 알릴 함수 (선택적 매개변수)
  final VoidCallback? onLikeChanged;

  const PostCard({
    super.key,
    required this.post,
    this.onLikeChanged, // 생성자에 추가
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  void _onLikePressed() {
    setState(() {
      if (widget.post.isLiked) {
        widget.post.isLiked = false;
        widget.post.likes--;
      } else {
        widget.post.isLiked = true;
        widget.post.likes++;
        if (widget.post.isDisliked) {
          widget.post.isDisliked = false;
          widget.post.dislikes--;
        }
      }
    });
    // ✨ [추가] 버튼 누른 후 부모에게 알림!
    widget.onLikeChanged?.call();
  }

  void _onDislikePressed() {
    setState(() {
      if (widget.post.isDisliked) {
        widget.post.isDisliked = false;
        widget.post.dislikes--;
      } else {
        widget.post.isDisliked = true;
        widget.post.dislikes++;
        if (widget.post.isLiked) {
          widget.post.isLiked = false;
          widget.post.likes--;
        }
      }
    });
    // ✨ [추가] 싫어요 때도 알림
    widget.onLikeChanged?.call();
  }

  void _navigateToDetail() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: widget.post)),
    );
    // 상세 페이지 갔다 왔을 때도 화면 갱신 및 부모 알림
    setState(() {});
    widget.onLikeChanged?.call(); // ✨ 추가
  }

  // ... (나머지 _buildPostImage 함수 및 build 메서드는 기존과 동일하므로 생략)
  Widget _buildPostImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, width: double.infinity, height: 200, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (기존 UI 코드 그대로 사용. 버튼의 onPressed는 위에서 만든 함수들을 연결)
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [CircleAvatar(radius: 20, backgroundImage: AssetImage(widget.post.userAvatarUrl)), const SizedBox(width: 12), Text(widget.post.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary))]),
          const SizedBox(height: 12),
          GestureDetector(onTap: _navigateToDetail, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.post.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 16)), const SizedBox(height: 4), Text(widget.post.content, style: const TextStyle(color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis), const SizedBox(height: 12), ClipRRect(borderRadius: BorderRadius.circular(8.0), child: _buildPostImage(widget.post.imageUrl))])),
          const SizedBox(height: 8),
          Row(children: [
            // ✨ _onLikePressed 연결 확인
            IconButton(icon: Icon(widget.post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: widget.post.isLiked ? AppColors.primary : AppColors.textSecondary, size: 20), onPressed: _onLikePressed),
            Text('${widget.post.likes}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 16),
            // ✨ _onDislikePressed 연결 확인
            IconButton(icon: Icon(widget.post.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: widget.post.isDisliked ? AppColors.primary : AppColors.textSecondary, size: 20), onPressed: _onDislikePressed),
            const SizedBox(width: 4),
            Text('${widget.post.dislikes}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 16),
            IconButton(icon: const Icon(Icons.chat_bubble_outline), color: AppColors.textSecondary, onPressed: _navigateToDetail),
            Text('${widget.post.comments.length}', style: const TextStyle(color: AppColors.textSecondary)),
          ]),
        ],
      ),
    );
  }
}