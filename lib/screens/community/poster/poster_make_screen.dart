import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_colors.dart';
import 'poster_preview_screen.dart';

class PosterMakeScreen extends StatefulWidget {
  const PosterMakeScreen({super.key});

  @override
  State<PosterMakeScreen> createState() => _PosterMakeScreenState();
}

class _PosterMakeScreenState extends State<PosterMakeScreen> {
  Uint8List? imageBytes;          // 🔥 Web & Mobile 모두 지원
  File? _imageFile;               // 모바일 전용
  final TextEditingController _textController = TextEditingController();

  /// 🔥 이미지 업로드 (Web은 bytes, Mobile은 File)
  Future<void> pickUserImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      if (kIsWeb) {
        // Web → Uint8List
        imageBytes = await file.readAsBytes();
      } else {
        // Mobile → File
        _imageFile = File(file.path);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("포스터 만들기", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("포스터를 선택하세요",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),

            /// 🔥 이미지 업로드 박스
            InkWell(
              onTap: pickUserImage,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: (imageBytes == null && _imageFile == null)
                    ? const Center(
                  child: Text(
                    "내 사진 업로드하기",
                    style: TextStyle(
                        color: AppColors.primary, fontSize: 16),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb
                      ? Image.memory(imageBytes!, fit: BoxFit.cover)
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text("포스터 문구 입력",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 12),

            TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "포스터에 들어갈 문구",
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 미리보기
            Center(
              child: InkWell(
                onTap: () {
                  if (imageBytes == null && _imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("포스터에 사용할 사진을 업로드해주세요."),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PosterPreviewScreen(
                        bytes: imageBytes,
                        file: _imageFile,
                        text: _textController.text,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: const Text("미리보기",
                      style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
