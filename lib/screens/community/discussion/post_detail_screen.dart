import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, String> post;

  const PostDetailScreen({super.key, required this.post});

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
        title: Text(post['title']!, style: const TextStyle(color: AppColors.textPrimary)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${post['user']} · ${post['time']}",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            Text(
              post['title']!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              post['content']!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
