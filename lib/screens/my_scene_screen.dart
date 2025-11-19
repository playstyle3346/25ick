import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/models.dart';
import '../../widgets/scene_menu_card.dart';
import 'emotion_note_screen.dart';
import 'quote_archive_screen.dart';
import 'scene_archive_screen.dart';

class MySceneScreen extends StatelessWidget {
  final List<Quote> quotes;
  final List<SceneGroup> sceneGroups;
  final List<EmotionNote> notes;

  const MySceneScreen({
    super.key,
    required this.quotes,
    required this.sceneGroups,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('마이씬',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            )),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SceneMenuCard(
            title: '장면 보관함',
            imageUrl: 'https://picsum.photos/id/101/800/600',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SceneArchiveScreen(sceneGroups: sceneGroups),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SceneMenuCard(
            title: '대사 보관함',
            imageUrl: 'https://picsum.photos/id/103/800/600',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuoteArchiveScreen(quotes: quotes),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SceneMenuCard(
            title: '감성 노트',
            imageUrl: 'https://picsum.photos/id/105/800/600',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmotionNoteScreen(notes: notes),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
