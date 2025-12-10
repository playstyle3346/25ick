import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart';

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({super.key});

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Uint8List? _imageBytes;   // 웹용 이미지
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _save() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("제목과 내용을 입력해주세요.")));
      return;
    }

    final post = Post(
      username: DummyRepository.myName.isEmpty
          ? "익명"
          : DummyRepository.myName,
      userAvatarUrl: DummyRepository.myProfileImage,
      title: _titleController.text,
      content: _contentController.text,

      imageBytes: _imageBytes,   // 🔥 핵심

      likes: 0,
      dislikes: 0,
      comments: [],
      createdAt: DateTime.now(),
      isFollowed: false,
      isLiked: false,
      isDisliked: false,
    );

    DummyRepository.addPost(post);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("작성하기", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              "완료",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "제목",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: Colors.white24),

            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "내용을 입력하세요",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.white38, size: 40),
                    SizedBox(height: 8),
                    Text("사진 추가", style: TextStyle(color: Colors.white38)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
