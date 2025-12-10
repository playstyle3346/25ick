import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/models.dart';
import '../../../../theme/app_colors.dart';
import 'add_emotion_note_screen.dart';
import 'emotion_note_detail_screen.dart';

class EmotionNoteScreen extends StatefulWidget {
  final List<EmotionNote> notes;
  const EmotionNoteScreen({super.key, required this.notes});

  @override
  State<EmotionNoteScreen> createState() => _EmotionNoteScreenState();
}

class _EmotionNoteScreenState extends State<EmotionNoteScreen> {
  late List<EmotionNote> _notes;

  @override
  void initState() {
    super.initState();
    // 부모로부터 받은 데이터를 로컬 상태로 복사하여 관리
    _notes = List.from(widget.notes);
  }

  // 새 노트 추가
  void _addNote(EmotionNote note) {
    setState(() => _notes.insert(0, note));
  }

  // 노트 삭제
  void _deleteNote(EmotionNote note) {
    setState(() {
      _notes.remove(note);
    });
  }

  // 삭제 확인 팝업
  Future<void> _showDeleteConfirmDialog(EmotionNote note) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('노트 삭제', style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('이 노트를 삭제하시겠습니까?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: <Widget>[
            TextButton(
              child: const Text('취소',
                  style: TextStyle(color: AppColors.textSecondary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('삭제',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                _deleteNote(note);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth(_notes);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("감성노트",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _notes.isEmpty
          ? const Center(
        child: Text(
          "작성된 노트가 없습니다.\n오른쪽 아래 + 버튼으로 새 노트를 추가하세요.",
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          final month = entry.key;
          final list = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...list.map((note) => _buildNoteCard(note)).toList(),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final newNote = await Navigator.push<EmotionNote>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEmotionNoteScreen(),
            ),
          );
          if (newNote != null) _addNote(newNote);
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // 노트 카드 (상세화면 연결 포함)
  Widget _buildNoteCard(EmotionNote note) {
    final dateStr = DateFormat('yyyy년 M월 d일').format(note.date);
    return GestureDetector(
      onTap: () async {
        // 상세 화면으로 이동
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmotionNoteDetailScreen(
              note: note,
              onDelete: () => _deleteNote(note), // 삭제 콜백 전달
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(dateStr,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz,
                  color: AppColors.textSecondary, size: 20),
              onPressed: () => _showDeleteConfirmDialog(note),
            ),
          ],
        ),
      ),
    );
  }

  // 월별 그룹핑
  Map<String, List<EmotionNote>> _groupByMonth(List<EmotionNote> notes) {
    final formatter = DateFormat('M월');
    final grouped = <String, List<EmotionNote>>{};
    for (var note in notes) {
      final key = formatter.format(note.date);
      grouped.putIfAbsent(key, () => []).add(note);
    }

    // 월 정렬 (최신순)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        int monthA = int.parse(a.replaceAll('월', ''));
        int monthB = int.parse(b.replaceAll('월', ''));
        return monthB.compareTo(monthA);
      });

    return {for (var k in sortedKeys) k: grouped[k]!};
  }
}
