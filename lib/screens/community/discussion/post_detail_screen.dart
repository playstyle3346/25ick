import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
// ✨ [필수] DummyRepository가 있는 경로를 import 해주세요.
// 예: import '../../data/dummy_repository.dart';
import '../../../data/dummy_repository.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, String> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  // ✨ [수정] 댓글 데이터 리스트 (이미지 경로 추가)
  // 기존 데이터에도 임시 이미지를 넣어두면 보기가 좋습니다.
  List<Map<String, String>> comments = [
    {
      "user": "익명1",
      "content": "오 저도 궁금했는데 정보 감사합니다!",
      "image": "assets/posters/getout.jpg" // 예시 이미지
    },
    {
      "user": "익명2",
      "content": "완전 공감합니다 ㅋㅋ",
      "image": "assets/posters/whiplash.jpg" // 예시 이미지
    },
  ];

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        // ✨ [수정] 고정값 "나" -> DummyRepository 변수 사용
        "user": DummyRepository.myName,

        "content": _commentController.text,

        // ✨ [추가] 내 프로필 이미지 추가
        "image": DummyRepository.myProfileImage,
      });
      _commentController.clear();
    });

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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 게시글 영역 ---
                  Row(
                    children: [
                      // 게시글 작성자 프로필 (게시글 데이터에 이미지가 없다면 기본 아이콘)
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage("assets/posters/lalaland.jpg"), // 게시글 작성자용 임시 이미지
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post['user'] ?? "Unknown",
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.post['time'] ?? "",
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
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

                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),

                  // --- 댓글 리스트 영역 ---
                  Text(
                    "댓글 ${comments.length}",
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✨ [수정] 댓글 작성자 프로필 이미지
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            // 이미지가 있으면 Asset 이미지 로드, 없으면 null
                            backgroundImage: comment['image'] != null
                                ? AssetImage(comment['image']!)
                                : null,
                            // 이미지가 없을 때만 아이콘 표시
                            child: comment['image'] == null
                                ? const Icon(Icons.person, size: 20, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 하단: 댓글 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.card,
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