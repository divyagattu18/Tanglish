import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Static flashcard — shows the Telugu word and all tense details at once.
class FlipCardWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const FlipCardWidget({
    super.key,
    required this.cardData,
  });

  @override
  Widget build(BuildContext context) {
    final difficulty = cardData['difficulty'] as String;
    final diffColor = difficulty == 'Beginner'
        ? AppColors.success
        : difficulty == 'Intermediate'
            ? AppColors.warning
            : AppColors.error;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Word section (gradient header) ────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFF9C94FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji — explicit fallback fonts ensure rendering on all platforms
                    Text(
                      cardData['emoji'] as String,
                      style: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Segoe UI Emoji',
                        fontFamilyFallback: [
                          'Apple Color Emoji',
                          'Noto Color Emoji',
                          'sans-serif',
                        ],
                      ),
                    ),
                    const Spacer(),
                    _DiffBadge(label: difficulty, color: diffColor),
                  ],
                ),
                const SizedBox(height: 10),
                // Telugu word — large and prominent
                Text(
                  cardData['front'] as String,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Tanglish · English meaning
                Text(
                  '${cardData['tanglish']}  ·  ${cardData['meaning']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // ── Tense section ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TenseRow(
                    label: 'Now',
                    text: cardData['present'] as String,
                    roman: cardData['presentRoman'] as String?,
                    color: const Color(0xFF4ECDC4),
                  ),
                  const SizedBox(height: 12),
                  _TenseRow(
                    label: 'Past',
                    text: cardData['past'] as String,
                    roman: cardData['pastRoman'] as String?,
                    color: const Color(0xFFFF9F43),
                  ),
                  const SizedBox(height: 12),
                  _TenseRow(
                    label: 'Future',
                    text: cardData['future'] as String,
                    roman: cardData['futureRoman'] as String?,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────────

class _DiffBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DiffBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TenseRow extends StatelessWidget {
  final String label;
  final String text;
  final String? roman;
  final Color color;
  const _TenseRow(
      {required this.label, required this.text, this.roman, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              if (roman != null)
                Text(
                  roman!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
