import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, String> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  // 댓글 데이터 리스트 (초기 더미 데이터)
  List<Map<String, String>> comments = [
    {"user": "익명1", "content": "오 저도 궁금했는데 정보 감사합니다!"},
    {"user": "익명2", "content": "완전 공감합니다 ㅋㅋ"},
  ];

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        "user": "나", // 내 닉네임
        "content": _commentController.text,
      });
      _commentController.clear(); // 입력창 비우기
    });

    // 키보드 내리기
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.post['title']!,
          style: const TextStyle(color: AppColors.textPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // 상단: 게시글 내용 + 댓글 리스트 (스크롤 가능 영역)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 게시글 영역 ---
                  Text(
                    "${widget.post['user']} · ${widget.post['time']}",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.post['title']!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.post['content']!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- 구분선 ---
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),

                  // --- 댓글 리스트 영역 ---
                  Text(
                    "댓글 ${comments.length}",
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // 댓글 목록 렌더링
                  ListView.separated(
                    shrinkWrap: true, // ScrollView 안에서 리스트뷰 사용 시 필수
                    physics: const NeverScrollableScrollPhysics(), // 바깥 스크롤과 충돌 방지
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 댓글 프로필
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 20, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          // 댓글 내용
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['user']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['content']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // 하단 여백 확보 (입력창에 가려지지 않게)
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 하단: 댓글 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.card, // 혹은 배경색보다 조금 밝은 색
              border: Border(
                top: BorderSide(color: Colors.white10),
              ),
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
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "댓글을 입력하세요...",
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 전송 버튼
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
          ),
        ],
      ),
    );
  }
}