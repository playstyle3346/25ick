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
        padding: const EdgeInsets.all(16.0),
        children: [
          // --------------------------
          // 장면 보관함
          // --------------------------
          SceneMenuCard(
            title: '장면 보관함',
            imageUrl: 'assets/images/scene1.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SceneArchiveScreen(
                    sceneGroups: DummyRepository.sceneGroups, // static
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // --------------------------
          // 대사 보관함
          // --------------------------
          SceneMenuCard(
            title: '대사 보관함',
            imageUrl: 'assets/images/scene2.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuoteArchiveScreen(
                    quotes: DummyRepository.quotes, // static
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // --------------------------
          // 감성노트
          // --------------------------
          SceneMenuCard(
            title: '감성 노트',
            imageUrl: 'assets/images/scene3.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmotionNoteScreen(
                    notes: DummyRepository.notes, // static
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
