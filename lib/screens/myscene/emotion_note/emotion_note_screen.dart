import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/models.dart';
import '../../../../theme/app_colors.dart';
import 'add_emotion_note_screen.dart';

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

  void _addNote(EmotionNote note) {
    setState(() => _notes.insert(0, note));
  }

  // ✨ [추가된 기능] 노트 삭제 함수
  void _deleteNote(EmotionNote note) {
    setState(() {
      _notes.remove(note);
    });
  }

  // ✨ [추가된 기능] 삭제 확인 대화상자
  Future<void> _showDeleteConfirmDialog(EmotionNote note) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card, // 테마에 맞게 배경색 조정
          title: const Text('노트 삭제', style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('이 노트를 삭제하시겠습니까?', style: TextStyle(color: AppColors.textSecondary)),
          actions: <Widget>[
            TextButton(
              child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                _deleteNote(note); // 삭제 실행
                Navigator.of(context).pop(); // 팝업 닫기
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
      body: ListView(
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
              // 리스트의 각 노트를 카드로 변환
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

  Widget _buildNoteCard(EmotionNote note) {
    final dateStr = DateFormat('yyyy년 M월 d일').format(note.date);
    return Container(
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
          // ✨ [수정됨] 삭제 팝업 연결
          IconButton(
            icon: const Icon(Icons.more_horiz,
                color: AppColors.textSecondary, size: 20),
            onPressed: () {
              _showDeleteConfirmDialog(note); // 버튼 클릭 시 삭제 팝업 호출
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<EmotionNote>> _groupByMonth(List<EmotionNote> notes) {
    final formatter = DateFormat('M월');
    final grouped = <String, List<EmotionNote>>{};
    for (var note in notes) {
      final key = formatter.format(note.date);
      grouped.putIfAbsent(key, () => []).add(note);
    }
    // 월별 정렬 (내림차순 등 필요에 따라 조정 가능)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        // "10월", "9월" 같은 문자열 비교를 위해 숫자만 추출해서 비교
        int monthA = int.parse(a.replaceAll('월', ''));
        int monthB = int.parse(b.replaceAll('월', ''));
        return monthB.compareTo(monthA); // 내림차순 (최신 월이 위로)
      });

    return {for (var k in sortedKeys) k: grouped[k]!};
  }
}