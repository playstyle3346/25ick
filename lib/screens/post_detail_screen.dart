import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/models.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();

  void _addComment(String comment) {
    setState(() => widget.post.comments.add(comment));
    _commentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("${post.username}님의 포스트",
            style: const TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(post),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.content,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const Text(
              "댓글",
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...post.comments.map(_buildComment).toList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildCommentInput(),
    );
  }

  Widget _buildHeader(Post post) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: NetworkImage(post.userAvatarUrl)),
        const SizedBox(width: 8),
        Text(post.username,
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        const Spacer(),
        const Icon(Icons.more_horiz, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _buildComment(String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://loremflickr.com/80/80/face'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(comment,
                style:
                const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "댓글을 남겨주세요.",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                if (_commentCtrl.text.trim().isNotEmpty) {
                  _addComment(_commentCtrl.text.trim());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
