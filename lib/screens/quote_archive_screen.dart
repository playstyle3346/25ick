import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

/// ------------------------------------------------------------
///  대사 보관함 (추가 / 삭제 / 상세보기)
/// ------------------------------------------------------------
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

  /// ------------------------------------------------------------
  /// Asset vs File 이미지 구분
  /// ------------------------------------------------------------
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith("assets/")) {
      return AssetImage(path);
    }
    return FileImage(File(path));
  }

  /// ------------------------------------------------------------
  /// 대사 추가
  /// ------------------------------------------------------------
  Future<void> _addQuote() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String text = "";
    String source = "";

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text("명대사 추가",
              style: TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "대사 내용",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                ),
                onChanged: (v) => text = v,
              ),
              TextField(
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "영화 제목",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                ),
                onChanged: (v) => source = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소",
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, {
                "text": text,
                "source": source,
              }),
              child: const Text("확인", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );

    if (result == null || result["text"]!.trim().isEmpty) return;

    setState(() {
      _quotes.insert(
        0,
        Quote(
          text: result["text"]!,
          source: result["source"]!,
          imageUrl: image.path,
        ),
      );
    });
  }

  /// ------------------------------------------------------------
  /// 삭제 Dialog
  /// ------------------------------------------------------------
  void _deleteQuote(int index) {
    setState(() {
      _quotes.removeAt(index);
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text("삭제",
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text("이 명대사를 삭제하시겠습니까?",
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소",
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              _deleteQuote(index);
              Navigator.pop(context);
            },
            child:
            const Text("삭제", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// UI
  /// ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("대사 보관함",
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
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
              MaterialPageRoute(
                builder: (_) => QuoteDetailScreen(quote: quote),
              ),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quote.source,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.star_border,
                      color: AppColors.primary, size: 22),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ------------------------------------------------------------
///  상세보기 화면
/// ------------------------------------------------------------
class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;
  const QuoteDetailScreen({super.key, required this.quote});

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith("assets/")) {
      return AssetImage(path);
    }
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 버튼 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:
                  const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.share,
                      color: AppColors.textSecondary, size: 22),
                  onPressed: () {},
                ),
              ],
            ),

            // 본문
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: _getImageProvider(quote.imageUrl),
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          quote.source,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "“${quote.text}”",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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