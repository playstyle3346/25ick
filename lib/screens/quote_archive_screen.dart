import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

class QuoteArchiveScreen extends StatefulWidget {
  final List<Quote> quotes;
  const QuoteArchiveScreen({super.key, required this.quotes});

  @override
  State<QuoteArchiveScreen> createState() => _QuoteArchiveScreenState();
}

class _QuoteArchiveScreenState extends State<QuoteArchiveScreen> {
  late List<Quote> _quotes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _quotes = List.from(widget.quotes);
  }

  // ✨ 이미지 경로 구분 (Asset vs File)
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('assets/')) return AssetImage(path);
    return FileImage(File(path));
  }

  // ✨ 대사 추가 함수
  Future<void> _addQuote() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String text = "";
        String source = "";
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text("명대사 추가", style: TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: "대사 내용", hintStyle: TextStyle(color: AppColors.textSecondary)),
                onChanged: (v) => text = v,
              ),
              TextField(
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: "영화 제목", hintStyle: TextStyle(color: AppColors.textSecondary)),
                onChanged: (v) => source = v,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소", style: TextStyle(color: AppColors.textSecondary))),
            TextButton(
              onPressed: () => Navigator.pop(context, {'text': text, 'source': source}),
              child: const Text("확인", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );

    if (result == null || result['text']!.isEmpty) return;

    setState(() {
      _quotes.insert(0, Quote(
        text: result['text']!,
        source: result['source']!,
        imageUrl: image.path,
      ));
    });
  }

  // ✨ 삭제 함수
  void _deleteQuote(int index) {
    setState(() => _quotes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("대사 보관함", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _quotes.length,
        itemBuilder: (context, index) {
          final quote = _quotes[index];
          return GestureDetector(
            onLongPress: () => _showDeleteDialog(index),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuoteDetailScreen(quote: quote)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: _getImageProvider(quote.imageUrl),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "“${quote.text}”",
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(quote.source, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.star_border, color: AppColors.primary, size: 22),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("삭제", style: TextStyle(color: AppColors.textPrimary)),
        content: const Text("이 명대사를 삭제하시겠습니까?", style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소", style: TextStyle(color: AppColors.textSecondary))),
          TextButton(onPressed: () { _deleteQuote(index); Navigator.pop(ctx); }, child: const Text("삭제", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;
  const QuoteDetailScreen({super.key, required this.quote});

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('assets/')) return AssetImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 26), onPressed: () => Navigator.pop(context)),
                IconButton(icon: const Icon(Icons.share, color: AppColors.textSecondary, size: 22), onPressed: () {}),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(image: _getImageProvider(quote.imageUrl), height: 200, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 16),
                        Text(quote.source, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        Text("“${quote.text}”", textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}