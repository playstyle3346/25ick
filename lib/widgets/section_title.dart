import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry margin;

  const SectionTitle({
    super.key,
    required this.title,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
