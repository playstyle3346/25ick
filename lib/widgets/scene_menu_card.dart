import 'dart:io';
import 'package:flutter/material.dart';

class SceneMenuCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;

  // 추가된 파라미터
  final Color backgroundColor;
  final Color textColor;

  const SceneMenuCard({
    super.key,
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.textColor = Colors.white,
  });

  ImageProvider? _getImageProvider(String? path) {
    if (path == null) return null;
    if (path.startsWith('assets/')) return AssetImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final provider = _getImageProvider(imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: provider == null ? backgroundColor : null,
          image: provider != null
              ? DecorationImage(
            image: provider,
            fit: BoxFit.cover,
          )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: provider == null
            ? Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
            : Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
