import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Widget _buildImage(String path) {
    if (path.startsWith("assets/")) return Image.asset(path);
    if (File(path).existsSync()) return Image.file(File(path));
    return Image.network(path);
  }

  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    AppState().addComment(widget.post, text);
    _commentCtrl.clear();
    setState(() {});
  }

  void _deleteComment(int index) {
    AppState().removeComment(widget.post, index);
    setState(() {});
  }

  void _toggleLike() {
    setState(() => AppState().toggleLike(widget.post));
  }

  void _toggleDislike() {
    setState(() => AppState().toggleDislike(widget.post));
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(post.username,
            style: const TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 제목
            Text(post.title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            /// 본문
            Text(post.content,
                style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 16),

            /// 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(post.imageUrl),
            ),

            const SizedBox(height: 16),

            /// 좋아요 / 싫어요
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: post.isLiked ? AppColors.primary : Colors.grey,
                    ),
                    onPressed: _toggleLike),
                Text("${post.likes}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(width: 16),

                IconButton(
                    icon: Icon(
                      post.isDisliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      color: post.isDisliked ? AppColors.primary : Colors.grey,
                    ),
                    onPressed: _toggleDislike),
                Text("${post.dislikes}",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),

            const Divider(color: Colors.white24),
            const SizedBox(height: 16),

            /// 댓글 개수
            Text("댓글 ${post.comments.length}",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),

            /// 댓글 리스트
            ...post.comments.asMap().entries.map((e) {
              final index = e.key;
              final text = e.value;

              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage("assets/posters/insideout.jpg"),
                ),
                title: Text(text, style: const TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _deleteComment(index),
                ),
              );
            }).toList(),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// 댓글 입력창
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: AppColors.background,
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "댓글 입력...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: _addComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
