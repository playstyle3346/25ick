import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/movie_algorithm.dart';
import '../../main_layout.dart';

class MovieTasteAnalysisScreen extends StatelessWidget {
  const MovieTasteAnalysisScreen({super.key});

  void _goToCommunity(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainLayout(initialIndex: 2),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userType = MovieAlgorithm.lastUserType;
    final keywords = MovieAlgorithm.typeKeywords[userType] ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _goToCommunity(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "'$userType' 유형으로 분석되었어요.",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _typeLabel(userType),
            const SizedBox(height: 30),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.8,
              children: keywords.map((k) => _TagChip(k)).toList(),
            ),

            const SizedBox(height: 40),

            InkWell(
              onTap: () => _goToCommunity(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text("완료", style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.primary)),
    );
  }
}
