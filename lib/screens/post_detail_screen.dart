import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart'; // ✨ [핵심] 데이터 저장소 연결

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 스크롤 제어용

  // ✨ [수정 1] 하드코딩된 "Jäger" 삭제 -> DummyRepository 사용
  // 이제 로그인한 사람의 닉네임과 프사를 가져옵니다.
  String get myNickname => DummyRepository.myName.isEmpty ? "익명" : DummyRepository.myName;
  String get myProfileImage => DummyRepository.myProfileImage;

  // 이미지 구별 함수
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
    _scrollController.dispose();
    super.dispose();
  }

  // ✨ [수정 2] 댓글 추가 함수 (저장소 연동)
  void _addComment() {
    if (_commentCtrl.text.trim().isEmpty) return;

    setState(() {
      widget.post.comments.add(
        Comment(
          username: myNickname, // 저장된 내 이름 사용
          text: _commentCtrl.text.trim(),
          avatarUrl: myProfileImage, // 저장된 내 프사 사용
        ),
      );
    });

    // ✨ [핵심] 댓글 개수 증가 (마이페이지 연동)
    DummyRepository.incrementCommentCount();

    // 입력창 비우기 & 키보드 내리기
    _commentCtrl.clear();
    FocusScope.of(context).unfocus();

    // 스크롤 맨 아래로 이동
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

  void _deleteComment(int index) {
    setState(() {
      widget.post.comments.removeAt(index);
    });
  }

  // 좋아요/싫어요 로직 생략 (기존과 동일)
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
      // ✨ [수정 3] 구조 변경: Column으로 감싸서 입력창이 항상 하단에 붙게 함
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

                  // ✨ [수정 4] 이미지가 있을 때만 그리기 (null 체크)
                  if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      // !를 붙여서 "null 아님"을 확신시킴
                      child: _buildDetailImage(post.imageUrl!),
                    ),
                    const SizedBox(height: 16),
                  ],

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
                          post.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                          color: post.isDisliked ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("${post.dislikes}", style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const Divider(color: Colors.white10, thickness: 1),
                  const SizedBox(height: 16),

                  // 통계
                  Row(
                    children: [
                      Text("댓글 ${post.comments.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Text("좋아요 ${post.likes}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 아바타 리스트 (생략 가능하나 유지)
                  if (post.comments.isNotEmpty)
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: post.comments.length > 5 ? 5 : post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return Align(
                            widthFactor: 0.7,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.background,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage(comment.avatarUrl ?? 'assets/posters/insideout.jpg'),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Text("첫 댓글의 주인공이 되어보세요!", style: TextStyle(color: Colors.grey, fontSize: 12)),

                  const SizedBox(height: 24),

                  // 댓글 리스트
                  ...post.comments.asMap().entries.map((entry) {
                    return _buildCommentItem(entry.key, entry.value);
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // 댓글 입력창 위젯 호출
          _buildCommentInput(),
        ],
      ),
    );
  }

  // --- 위젯 분리 ---

  Widget _buildHeader(Post post) {
    return Row(
      children: [
        CircleAvatar(radius: 16, backgroundImage: AssetImage(post.userAvatarUrl)),
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
                if (post.isLiked) ...[
                  const Icon(Icons.favorite, size: 12, color: Colors.orangeAccent),
                  const Text(" 1", style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
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

  Widget _buildCommentItem(int index, Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(comment.avatarUrl ?? 'assets/posters/insideout.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment.username,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),

                    // ✨ [수정 5] 내 닉네임과 같을 때만 삭제 버튼 표시
                    if (comment.username == myNickname)
                      GestureDetector(
                        onTap: () => _showDeleteConfirmDialog(index),
                        child: const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
                      ),
                  ],
                ),
                const Text("방금 전", style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 6),
                Text(comment.text, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✨ [수정 6] 화살표 버튼 있는 입력창 UI
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
                  color: AppColors.background,
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
                  onSubmitted: (value) => _addComment(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _addComment,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.send, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}