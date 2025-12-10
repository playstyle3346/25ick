import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../main_layout.dart';

class PosterPreviewScreen extends StatelessWidget {
  final Uint8List? bytes; // Web 이미지
  final File? file;       // Mobile 이미지
  final String text;

  const PosterPreviewScreen({
    super.key,
    required this.bytes,
    required this.file,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final Widget posterImage = bytes != null
        ? Image.memory(bytes!, width: 320, fit: BoxFit.cover)
        : Image.file(file!, width: 320, fit: BoxFit.cover);

    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔥 X 버튼을 오른쪽 위로 이동 + 커뮤니티 홈(메인레이아웃 2번탭)으로 이동
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const MainLayout(initialIndex: 2)),
                    (route) => false,
              );
            },
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔥 포스터 이미지 (위)
              posterImage,
              const SizedBox(height: 20),

              /// 🔥 문구 (아래)
              Container(
                width: 320,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🔥 출력하기 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "출력하기",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
