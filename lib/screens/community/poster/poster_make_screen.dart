import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_colors.dart';

class PosterMakeScreen extends StatefulWidget {
  const PosterMakeScreen({super.key});

  @override
  State<PosterMakeScreen> createState() => _PosterMakeScreenState();
}

class _PosterMakeScreenState extends State<PosterMakeScreen> {
  File? _uploadedImage;
  String? selectedPoster; // assets 선택한 포스터
  final TextEditingController _textController = TextEditingController();

  final List<String> posters = [
    "assets/posters/poster1.jpg",
    "assets/posters/poster2.jpg",
    "assets/posters/poster3.jpg",
    "assets/posters/poster4.jpg",
    "assets/posters/poster5.jpg",
  ];

  /// 🔥 업로드 이미지 선택
  Future<void> pickUserImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        _uploadedImage = File(file.path);
        selectedPoster = null; // 업로드하면 기존 선택 해제
      });
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
            /// -------------------------------
            /// 포스터 선택 안내
            /// -------------------------------
            const Text(
              "포스터를 선택하세요",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),

            /// -------------------------------
            /// 🔥 사용자 업로드 버튼
            /// -------------------------------
            InkWell(
              onTap: pickUserImage,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: _uploadedImage == null
                    ? const Center(
                  child: Text(
                    "내 사진 업로드하기",
                    style: TextStyle(color: AppColors.primary, fontSize: 16),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _uploadedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),


            /// -------------------------------
            /// 포스터 문구 입력
            /// -------------------------------
            const Text(
              "포스터 문구 입력",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
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

            /// -------------------------------
            /// 미리보기 버튼
            /// -------------------------------
            Center(
              child: InkWell(
                onTap: () {
                  if (_uploadedImage == null && selectedPoster == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("포스터를 선택하거나 업로드해주세요."),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PosterPreviewScreen(
                        imageFile: _uploadedImage,
                        assetPath: selectedPoster,
                        text: _textController.text,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: const Text("미리보기", style: TextStyle(color: AppColors.primary)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------
/// 🔥 미리보기 화면
/// --------------------------------------------------------------
class PosterPreviewScreen extends StatelessWidget {
  final File? imageFile; // 업로드 이미지
  final String? assetPath; // assets 이미지
  final String text;

  const PosterPreviewScreen({
    super.key,
    required this.imageFile,
    required this.assetPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final Widget posterWidget = imageFile != null
        ? Image.file(imageFile!, width: 300, fit: BoxFit.cover)
        : Image.asset(assetPath!, width: 300, fit: BoxFit.cover);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            posterWidget,
            Container(
              width: 300,
              padding: const EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.6),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
