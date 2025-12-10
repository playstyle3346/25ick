import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../data/dummy_repository.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, String> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  late List<Map<String, String>> comments;

  @override
  void initState() {
    super.initState();

    // ⭐ 여기서 새 글인지 기존 글인지 구분
    if (widget.post["isNew"] == "true") {
      comments = []; // ⭐ 새 글 → 댓글 없음
    } else {
      // ⭐ 기존 글 → 기본 댓글 2개 하드코딩으로 제공
      comments = [
        {
          "user": "익명1",
          "content": "오 저도 궁금했는데 정보 감사합니다!",
          "image": "assets/posters/getout.jpg"
        },
        {
          "user": "익명2",
          "content": "완전 공감합니다 ㅋㅋ",
          "image": "assets/posters/whiplash.jpg"
        },
      ];
    }
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        "user": DummyRepository.myName,
        "content": _commentController.text,
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
                  // --- 게시글 상단 ---
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                        AssetImage("assets/posters/lalaland.jpg"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.post['user'] ?? "Unknown",
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.post['time'] ?? "",
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(widget.post['title']!,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  Text(widget.post['content']!,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.6)),

                  const SizedBox(height: 40),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),

                  // --- 댓글 ---
                  Text("댓글 ${comments.length}",
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  if (comments.isEmpty)
                    const Text("첫 댓글을 남겨보세요!",
                        style: TextStyle(color: Colors.grey))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final c = comments[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: AssetImage(c["image"]!),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c["user"]!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(c["content"]!,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // --- 댓글 입력창 ---
          Container(
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
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send,
                          size: 20, color: Colors.black),
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
