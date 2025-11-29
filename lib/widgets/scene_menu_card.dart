import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SceneMenuCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const SceneMenuCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  // 헬퍼 함수: URL이 'assets/'로 시작하는지 확인하여 에셋 경로인지 판단
  bool get isAsset => imageUrl.startsWith('assets/');

  // 헬퍼 함수: imageUrl에 따라 적절한 ImageProvider를 반환
  ImageProvider<Object> _getImageProvider() {
    if (isAsset) {
      // 에셋 경로일 경우 AssetImage 사용
      // 이 로직이 ArgumentError를 해결합니다.
      return AssetImage(imageUrl);
    } else {
      // 그 외 (네트워크 URL)일 경우 NetworkImage 사용
      return NetworkImage(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              // ⭐️ 수정된 동적 ImageProvider 사용
              image: _getImageProvider(),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}