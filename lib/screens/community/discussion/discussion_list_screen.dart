import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'post_detail_screen.dart';
import 'write_post_screen.dart';

class DiscussionListScreen extends StatefulWidget {
  const DiscussionListScreen({super.key});

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();
}

class _DiscussionListScreenState extends State<DiscussionListScreen> {
  final List<Map<String, String>> posts = [
    {
      "user": "익명",
      "time": "방금 전",
      "title": "안녕",
      "content": "안녕하세요",
    },
    {
      "user": "유니",
      "time": "3초 전",
      "title": "투슬리스 키링 지정 별 수량 공유합니다",
      "content": "방금 영화를 보고 왔는데 키링 수량이 부족하더라구요. 혹시 본 사람?",
    },
    {
      "user": "모비",
      "time": "30초 전",
      "title": "지브리 다큐 본 사람?",
      "content": "지브리 팬인데 감동 받았다… 여운 미쳤다…",
    },
    {
      "user": "하동",
      "time": "5분 전",
      "title": "쥬라기월드 배우들 내한 소식 봤음?",
      "content": "스케줄 보니까 티켓팅 곧 열릴 듯? 정보 공유해봐요!",
    },
  ];

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
        title: const Text(
          "굿즈/잡담",
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.black),
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WritePostScreen()),
          );

          if (newPost != null) {
            setState(() {
              posts.insert(0, newPost);
            });
          }
        },
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(post: post),
                ),
              );
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post['user']} · ${post['time']}",
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          post['title']!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          post['content']!,
                          style: const TextStyle(color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
