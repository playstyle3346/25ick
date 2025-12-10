import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String get myNickname => DummyRepository.myName;
  String get myProfileImage => DummyRepository.myProfileImage;

  @override
  void dispose() {
    _commentCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// ==========================================
  /// 이미지 렌더링: imageBytes → imageUrl → 없음
  /// ==========================================
  Widget _buildPostImage(Post post) {
    if (post.imageBytes != null) {
      return Image.memory(post.imageBytes!, fit: BoxFit.cover);
    }

    if (post.imageUrl == null || post.imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (post.imageUrl!.startsWith("assets/")) {
      return Image.asset(post.imageUrl!, fit: BoxFit.cover);
    }

    return Image.file(File(post.imageUrl!), fit: BoxFit.cover);
  }

  /// 댓글 추가
  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.post.comments.add(
        Comment(
          username: myNickname,
          text: text,
          avatarUrl: myProfileImage,
        ),
      );
    });

    DummyRepository.incrementCommentCount();

    _commentCtrl.clear();
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 댓글 삭제
  void _deleteComment(int index) {
    setState(() {
      widget.post.comments.removeAt(index);
    });
  }

  /// 좋아요 / 싫어요
  void _onLikePressed() {
    setState(() {
      widget.post.toggleLike();
    });
  }

  void _onDislikePressed() {
    setState(() {
      widget.post.toggleDislike();
    });
  }

  Future<void> _showDeleteConfirmDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('댓글 삭제', style: TextStyle(color: Colors.white)),
          content: const Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.grey)),
          actions: [
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                _deleteComment(index);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          "${post.username}님의 포스트",
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
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

                  // 제목
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 본문
                  Text(
                    post.content,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 이미지
                  if (post.imageBytes != null ||
                      (post.imageUrl != null && post.imageUrl!.isNotEmpty)) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _buildPostImage(post),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 좋아요/싫어요
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _onLikePressed,
                        icon: Icon(
                          post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: post.isLiked ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      Text("${post.likes}", style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: _onDislikePressed,
                        icon: Icon(
                          post.isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          color: post.isDisliked ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      Text("${post.dislikes}", style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  const Divider(color: Colors.white10),
                  const SizedBox(height: 12),

                  // 댓글
                  Text(
                    "댓글 ${post.comments.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (post.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text("첫 댓글을 남겨보세요!", style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...post.comments.asMap().entries.map(
                          (entry) => _buildCommentItem(entry.key, entry.value),
                    ),

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
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(post.userAvatarUrl),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.username,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Text("10분 전", style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem(int index, Comment comment) {
    final avatar = comment.avatarUrl?.isNotEmpty == true
        ? comment.avatarUrl!
        : "assets/posters/insideout.jpg";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: AssetImage(avatar)),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    if (comment.username == myNickname)
                      GestureDetector(
                        onTap: () => _showDeleteConfirmDialog(index),
                        child: const Icon(Icons.more_horiz,
                            size: 16, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                ),
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
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addComment,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, size: 20, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
