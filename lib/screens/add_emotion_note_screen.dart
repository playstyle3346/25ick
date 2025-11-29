import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

class AddEmotionNoteScreen extends StatefulWidget {
  const AddEmotionNoteScreen({super.key});

  @override
  State<AddEmotionNoteScreen> createState() => _AddEmotionNoteScreenState();
}

class _AddEmotionNoteScreenState extends State<AddEmotionNoteScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  // ✨ [추가됨] 화면이 종료될 때 컨트롤러를 정리해주는 함수 (메모리 누수 방지)
  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    // ✨ [수정됨] 내용이 비어있으면 SnackBar로 안내 메시지 띄우기
    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 모두 입력해주세요.'),
          backgroundColor: Colors.redAccent, // 경고 느낌의 색상
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final note = EmotionNote(
      title: title,
      body: body,
      date: DateTime.now(),
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("새 노트 작성",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "제목을 입력하세요",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _bodyCtrl,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "내용을 입력하세요...",
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("저장하기",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}