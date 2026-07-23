import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PhraseCard extends StatelessWidget {
  final String englishPhrase;
  final String teluguPhrase;
  final String transliteration;
  final bool isCompleted;

  const PhraseCard({
    super.key,
    required this.englishPhrase,
    required this.teluguPhrase,
    required this.transliteration,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? AppColors.success
              : AppColors.primary.withOpacity(0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // English label
          _Chip(label: 'ENGLISH', color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            englishPhrase,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(thickness: 1.5),
          ),
          // Telugu label
          _Chip(label: 'TELUGU', color: AppColors.secondary),
          const SizedBox(height: 12),
          Text(
            teluguPhrase,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Transliteration
          Text(
            transliteration,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
