import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/dummy_repository.dart';

import '../../widgets/scene_menu_card.dart';
import 'myscene/emotion_note/emotion_note_screen.dart';
import 'quote_archive_screen.dart';
import 'scene_archive_screen.dart';

class MySceneScreen extends StatelessWidget {
  const MySceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '마이씬',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // --------------------------
          // 장면 보관함 (따뜻한 살구색)
          // --------------------------
          SceneMenuCard(
            title: "장면 보관함",
            backgroundColor: const Color(0xFFF6D7A7),
            textColor: Colors.black87,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SceneArchiveScreen(
                    sceneGroups: DummyRepository.sceneGroups,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // --------------------------
          // 대사 보관함 (라이트 옐로우)
          // --------------------------
          SceneMenuCard(
            title: "대사 보관함",
            backgroundColor: const Color(0xFFFFF3B0),
            textColor: Colors.black87,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuoteArchiveScreen(
                    quotes: DummyRepository.quotes,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // --------------------------
          // 감성 노트 (라이트 민트색)
          // --------------------------
          SceneMenuCard(
            title: "감성 노트",
            backgroundColor: const Color(0xFFCCF5D3),
            textColor: Colors.black87,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmotionNoteScreen(
                    notes: DummyRepository.notes,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
