import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class MyFollowersScreen extends StatelessWidget {
  const MyFollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final followedPosts = AppState().posts.where((p) => p.isFollowed).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("팔로우한 사람들"),
      ),
      body: followedPosts.isEmpty
          ? const Center(
          child: Text("팔로우한 사람이 없습니다.",
              style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
        itemCount: followedPosts.length,
        itemBuilder: (context, index) {
          final post = followedPosts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(post.userAvatarUrl),
            ),
            title: Text(post.username,
                style: const TextStyle(color: AppColors.textPrimary)),
            subtitle: Text(post.title,
                style: const TextStyle(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          );
        },
      ),
    );
  }
}
