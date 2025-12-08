import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({super.key});

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _save() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("제목과 내용을 입력해주세요.")));
      return;
    }

    final post = Post(
      username: "나 (Me)",
      userAvatarUrl: "assets/posters/insideout.jpg",
      title: _titleController.text,
      content: _contentController.text,
      imageUrl: "assets/posters/lalaland.jpg",
      createdAt: DateTime.now(),
    );

    AppState().addPost(post);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("작성하기"),
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text("완료", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: "제목"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: "내용"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
