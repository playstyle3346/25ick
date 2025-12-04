import 'dart:io'; // 파일 처리를 위해 필요
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();

  // ✨ [핵심] 이미지 구별 함수 (Asset vs File)
  Widget _buildDetailImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), fit: BoxFit.cover);
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _addComment(String comment) {
    setState(() => widget.post.comments.add(comment));
    _commentCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _deleteComment(int index) {
    setState(() => widget.post.comments.removeAt(index));
  }

  void _onLikePressed() {
    setState(() {
      if (widget.post.isLiked) {
        widget.post.isLiked = false; widget.post.likes--;
      } else {
        widget.post.isLiked = true; widget.post.likes++;
        if (widget.post.isDisliked) { widget.post.isDisliked = false; widget.post.dislikes--; }
      }
    });
  }

  void _onDislikePressed() {
    setState(() {
      if (widget.post.isDisliked) {
        widget.post.isDisliked = false; widget.post.dislikes--;
      } else {
        widget.post.isDisliked = true; widget.post.dislikes++;
        if (widget.post.isLiked) { widget.post.isLiked = false; widget.post.likes--; }
      }
    });
  }

  Future<void> _showDeleteConfirmDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('댓글 삭제', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('정말 이 댓글을 삭제하시겠습니까?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)), onPressed: () => Navigator.pop(context)),
          TextButton(child: const Text('삭제', style: TextStyle(color: Colors.redAccent)), onPressed: () { _deleteComment(index); Navigator.pop(context); }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("${post.username}님의 포스트", style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(post),
            const SizedBox(height: 16),
            Text(post.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(post.content, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6)),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              // ✨ 이미지 함수 적용
              child: _buildDetailImage(post.imageUrl),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(onPressed: _onLikePressed, icon: Icon(post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: post.isLiked ? AppColors.primary : Colors.grey)),
              Text("${post.likes}", style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 16),
              IconButton(onPressed: _onDislikePressed, icon: Icon(post.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: post.isDisliked ? AppColors.primary : Colors.grey)),
              // ✨ 싫어요 숫자 추가
              const SizedBox(width: 4),
              Text("${post.dislikes}", style: const TextStyle(color: Colors.white)),
            ]),
            const Divider(color: Colors.white10),
            Row(
              children: [
                Text("댓글 ${post.comments.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Text("좋아요 ${post.likes}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (post.comments.isNotEmpty) SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: post.comments.length > 5 ? 5 : post.comments.length, itemBuilder: (context, index) => Align(widthFactor: 0.7, child: CircleAvatar(radius: 18, backgroundColor: AppColors.background, child: CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/posters/insideout.jpg')))))) else const Text("첫 댓글의 주인공이 되어보세요!", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 24),
            ...post.comments.asMap().entries.map((entry) => _buildCommentItem(entry.key, entry.value)).toList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildCommentInput(),
    );
  }

  Widget _buildHeader(Post post) {
    return Row(children: [CircleAvatar(radius: 16, backgroundImage: AssetImage(post.userAvatarUrl)), const SizedBox(width: 8), Text(post.username, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))]);
  }

  Widget _buildCommentItem(int index, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(children: [const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/posters/insideout.jpg')), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("익명", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), GestureDetector(onTap: () => _showDeleteConfirmDialog(index), child: const Icon(Icons.more_horiz, size: 16, color: Colors.grey))]), const SizedBox(height: 6), Text(comment, style: const TextStyle(color: Colors.white70, fontSize: 14))]))]),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: Colors.white10))),
      child: SafeArea(child: Row(children: [GestureDetector(onTap: () { if (_commentCtrl.text.trim().isNotEmpty) _addComment(_commentCtrl.text.trim()); }, child: Container(width: 32, height: 32, decoration: BoxDecoration(border: Border.all(color: AppColors.primary), shape: BoxShape.circle), child: const Icon(Icons.add, color: AppColors.primary, size: 20))), const SizedBox(width: 12), Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16), height: 40, decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)), child: TextField(controller: _commentCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "댓글을 남겨주세요.", hintStyle: TextStyle(color: Colors.grey, fontSize: 13), border: InputBorder.none), onSubmitted: (v) { if (v.trim().isNotEmpty) _addComment(v.trim()); })))])),
    );
  }
}