import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import 'add_emotion_note_screen.dart'; // ✅ 새 페이지 import

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
    _notes = List.from(widget.notes);
  }

  void _addNote(EmotionNote note) {
    setState(() => _notes.insert(0, note));
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
          IconButton(
            icon: const Icon(Icons.more_horiz,
                color: AppColors.textSecondary, size: 20),
            onPressed: () {},
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
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return {for (var k in sortedKeys) k: grouped[k]!};
  }
}
