import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart'; // ✨ AppColors import

class SceneArchiveScreen extends StatelessWidget {
  final List<SceneGroup> sceneGroups;
  const SceneArchiveScreen({super.key, required this.sceneGroups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✨ Palette.background -> AppColors.background
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("장면 보관함",
            style: TextStyle(
              // ✨ Colors.white -> AppColors.textPrimary
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        // ✨ 뒤로가기 버튼 색상 통일
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sceneGroups.length,
        itemBuilder: (context, index) {
          final group = sceneGroups[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.title,
                style: const TextStyle(
                  // ✨ 텍스트 색상 통일
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: group.scenes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final scene = group.scenes[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SceneDetailScreen(imageUrl: scene.imageUrl),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          scene.imageUrl,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

// ────────────────────────────────
// 장면 크게 보기 (줌 가능) 화면
// ────────────────────────────────
class SceneDetailScreen extends StatelessWidget {
  final String imageUrl;
  const SceneDetailScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✨ 배경색 통일 (이미지 보기라 검정색이 좋지만 일관성을 위해 AppColors 사용)
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}