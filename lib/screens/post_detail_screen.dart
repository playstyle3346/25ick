import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';
import '../state/app_state.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String get myNickname =>
      DummyRepository.myName.isEmpty ? "익명" : DummyRepository.myName;

  @override
  void dispose() {
    _commentCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    AppState().addComment(widget.post, text); // ✅ 전역 상태 업데이트

    _commentCtrl.clear();
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteComment(int index) {
    AppState().removeComment(widget.post, index);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("${post.username}님의 포스트",
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(post),
                  const SizedBox(height: 16),
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: post.imageUrl!.startsWith('assets/')
                          ? Image.asset(post.imageUrl!, fit: BoxFit.cover)
                          : Image.file(File(post.imageUrl!), fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white10, thickness: 1),
                  const SizedBox(height: 12),
                  Text("댓글 ${post.comments.length}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...post.comments.asMap().entries.map((entry) {
                    return _buildCommentItem(entry.key, entry.value);
                  }).toList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader(Post post) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: AssetImage(post.userAvatarUrl)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.username,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const Text("10분 전",
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem(int index, Comment comment) {
    final avatarPath =
    comment.avatarUrl?.isNotEmpty == true ? comment.avatarUrl! : 'assets/posters/insideout.jpg';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: AssetImage(avatarPath)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    if (comment.username == myNickname)
                      GestureDetector(
                        onTap: () => _showDeleteConfirmDialog(index),
                        child: const Icon(Icons.more_horiz,
                            size: 16, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(comment.text,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('댓글 삭제',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('정말 이 댓글을 삭제하시겠습니까?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              child: const Text('취소',
                  style: TextStyle(color: AppColors.textSecondary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('삭제',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                _deleteComment(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "댓글을 입력하세요...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _addComment(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addComment,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child:
                const Icon(Icons.send, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
