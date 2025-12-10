import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지를 고르기 위해 필요
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../data/dummy_repository.dart'; // ✨ [핵심] 여기에 저장해야 마이페이지랑 연결됨

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({super.key});

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // ✨ [추가] 선택된 이미지를 담을 변수
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // ✨ [추가] 갤러리에서 사진 가져오는 함수
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _save() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("제목과 내용을 입력해주세요.")));
      return;
    }

    final post = Post(
      // ✨ [수정 1] "나 (Me)" 대신 로그인한 실제 닉네임 사용
      username: DummyRepository.myName.isEmpty ? "익명" : DummyRepository.myName,
      userAvatarUrl: DummyRepository.myProfileImage, // 내 프사 사용

      title: _titleController.text,
      content: _contentController.text,

      // ✨ [수정 2] 이미지가 없으면 null을 넣음 (이제 라라랜드 안 나옴!)
      imageUrl: _pickedImage?.path,

      likes: 0,
      dislikes: 0,
      comments: [],
      createdAt: DateTime.now(),
      isFollowed: false,
      isLiked: false,
      isDisliked: false,
    );

    // ✨ [수정 3] AppState 대신 DummyRepository에 저장 (마이페이지 연동)
    DummyRepository.addPost(post);

    // 뒤로가기 (true를 반환하여 목록 갱신 신호)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("작성하기", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white), // 뒤로가기 버튼 흰색
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text("완료", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView( // 스크롤 가능하게 변경
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 제목 입력
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "제목",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: Colors.white24),

            // 내용 입력
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 10, // 넉넉하게 늘림
              decoration: const InputDecoration(
                hintText: "내용을 입력하세요",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),

            // ✨ [추가] 이미지 첨부 버튼 UI
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // 어두운 회색 박스
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                // 이미지가 있으면 보여주고, 없으면 카메라 아이콘 표시
                child: _pickedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_pickedImage!.path),
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_photo_alternate_outlined, color: Colors.white38, size: 40),
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