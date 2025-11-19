import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          image: imageUrl != null
              ? DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: imageUrl == null
            ? Center(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        )
            : Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
