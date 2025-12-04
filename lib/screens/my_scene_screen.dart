import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
// ✨ 데이터 저장소 import
import '../../data/dummy_repository.dart';
import '../../widgets/scene_menu_card.dart';
import 'emotion_note_screen.dart';
import 'quote_archive_screen.dart';
import 'scene_archive_screen.dart';

class MySceneScreen extends StatelessWidget {
  // ❌ 이전 코드: 부모로부터 데이터를 받아오는 방식 (삭제됨)
  // final List<Quote> quotes;
  // final List<SceneGroup> sceneGroups;
  // final List<EmotionNote> notes;

  // ✨ 수정된 코드: 인자 없이 생성
  const MySceneScreen({super.key});

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
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SceneMenuCard(
            title: '장면 보관함',
            // ✨ 에셋 이미지 사용
            imageUrl: 'assets/images/scene1.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ✨ DummyRepository에서 직접 데이터 가져오기
                  builder: (_) => SceneArchiveScreen(sceneGroups: DummyRepository.sceneGroups),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SceneMenuCard(
            title: '대사 보관함',
            // ✨ 에셋 이미지 사용
            imageUrl: 'assets/images/scene2.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ✨ DummyRepository에서 직접 데이터 가져오기
                  builder: (_) => QuoteArchiveScreen(quotes: DummyRepository.quotes),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SceneMenuCard(
            title: '감성 노트',
            // ✨ 에셋 이미지 사용
            imageUrl: 'assets/images/scene3.jpg', // 노트 관련 이미지로 설정
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ✨ DummyRepository에서 직접 데이터 가져오기
                  builder: (_) => EmotionNoteScreen(notes: DummyRepository.notes),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}