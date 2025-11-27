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

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _addComment(String comment) {
    setState(() {
      widget.post.comments.add(comment);
    });
    _commentCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _deleteComment(int index) {
    setState(() {
      widget.post.comments.removeAt(index);
    });
  }

  // ✨ 좋아요 로직
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
  }

  // ✨ 싫어요 로직
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
  }

  Future<void> _showDeleteConfirmDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('댓글 삭제', style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('정말 이 댓글을 삭제하시겠습니까?', style: TextStyle(color: AppColors.textSecondary)),
          actions: <Widget>[
            TextButton(
              child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
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

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("${post.username}님의 포스트",
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
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
            // 1. 헤더
            _buildHeader(post),
            const SizedBox(height: 16),

            // 2. 제목 & 본문
            Text(
              post.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '"기억의 가장자리에서\n끝내 말해지지 못한 마음을 어루만진다"',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag("#여운"),
                const SizedBox(width: 8),
                _buildTag("#다채로운"),
                const SizedBox(width: 8),
                _buildTag("#감성영화"),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              post.content,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 20),

            // 3. 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),

            // ✨ [수정됨] 여기에 좋아요/싫어요 버튼을 추가해야 동작합니다!
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _onLikePressed, // 함수 연결
                  icon: Icon(
                    post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: post.isLiked ? AppColors.primary : Colors.grey,
                  ),
                ),
                Text("${post.likes}", style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _onDislikePressed, // 함수 연결
                  icon: Icon(
                    post.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                    color: post.isDisliked ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            ),

            const Divider(color: Colors.white10, thickness: 1),
            const SizedBox(height: 16),

            // ✨ 4. 실시간 통계 (댓글 및 좋아요 수 변화 반영)
            Row(
              children: [
                Text("댓글 ${post.comments.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Text("좋아요 ${post.likes}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            // ✨ 5. 아바타 파일 (댓글이 늘어나면 사진이 겹치며 추가됨)
            if (post.comments.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // 최대 5개까지만 보여주기 (너무 길어짐 방지)
                  itemCount: post.comments.length > 5 ? 5 : post.comments.length,
                  itemBuilder: (context, index) {
                    return Align(
                      widthFactor: 0.7, // 사진끼리 겹치게 하는 핵심 속성
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.background, // 테두리 효과
                        child: CircleAvatar(
                          radius: 16,
                          // 댓글마다 다른 얼굴 랜덤 표시
                          backgroundImage: NetworkImage('https://loremflickr.com/100/100/face?random=${index + 50}'),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Text("첫 댓글의 주인공이 되어보세요!", style: TextStyle(color: Colors.grey, fontSize: 12)),

            const SizedBox(height: 24),

            // 6. 댓글 리스트
            ...post.comments.asMap().entries.map((entry) {
              return _buildCommentItem(entry.key, entry.value);
            }).toList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildCommentInput(),
    );
  }

  // --- 위젯 분리 ---

  Widget _buildHeader(Post post) {
    return Row(
      children: [
        CircleAvatar(radius: 16, backgroundImage: NetworkImage(post.userAvatarUrl)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(post.username,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 4),
                // 상단에는 단순히 내가 좋아요 눌렀는지 표시만 함 (기능 X)
                if (post.isLiked) ...[
                  const Icon(Icons.favorite, size: 12, color: Colors.orangeAccent),
                ]
              ],
            ),
            const Text("10분 전", style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
    );
  }

  Widget _buildCommentItem(int index, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 작성자 아바타 (랜덤)
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://loremflickr.com/80/80/face?lock=$index'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("익명",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    GestureDetector(
                      onTap: () => _showDeleteConfirmDialog(index),
                      child: const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const Text("방금 전", style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 6),
                Text(comment, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
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
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _commentCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "댓글을 남겨주세요.",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) _addComment(value.trim());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}