import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SceneDetailScreen extends StatelessWidget {
  final String imageUrl;
  const SceneDetailScreen({super.key, required this.imageUrl});

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('assets/')) return AssetImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image(
            image: _getImageProvider(imageUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}