import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated 3-D flip card.
/// The caller owns [isFlipped]; tapping fires [onFlip].
class FlipCardWidget extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final bool isFlipped;
  final VoidCallback onFlip;

  const FlipCardWidget({
    super.key,
    required this.cardData,
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(FlipCardWidget old) {
    super.didUpdateWidget(old);
    if (widget.isFlipped != old.isFlipped) {
      widget.isFlipped ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final angle = _anim.value * math.pi;
          final showFront = angle < math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? _Front(cardData: widget.cardData)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _Back(cardData: widget.cardData),
                  ),
          );
        },
      ),
    );
  }
}

// ─── Front face ────────────────────────────────────────────────────────────────

class _Front extends StatelessWidget {
  final Map<String, dynamic> cardData;
  const _Front({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF9C94FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cardData['emoji'] as String,
            style: const TextStyle(fontSize: 52),
          ),
          const SizedBox(height: 14),
          // Telugu script — large and prominent on the front
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
          const SizedBox(height: 6),
          // Tanglish pronunciation hint
          Text(
            cardData['tanglish'] as String,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.80),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_rounded,
                  color: Colors.white.withOpacity(0.65), size: 18),
              const SizedBox(width: 6),
              Text(
                'Tap to reveal',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Back face ─────────────────────────────────────────────────────────────────

class _Back extends StatelessWidget {
  final Map<String, dynamic> cardData;
  const _Back({required this.cardData});

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ───────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cardData['emoji'] as String,
                    style: const TextStyle(fontSize: 44)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tanglish pronunciation
                      Text(
                        cardData['tanglish'] as String,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // English meaning
                      Text(
                        cardData['meaning'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _DiffBadge(label: difficulty, color: diffColor),
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            // ── Tenses in Telugu script ───────────────────────────────────
            _TenseRow(
              label: 'Now',
              text: cardData['present'] as String,
              color: const Color(0xFF4ECDC4),
            ),
            const SizedBox(height: 8),
            _TenseRow(
              label: 'Past',
              text: cardData['past'] as String,
              color: const Color(0xFFFF9F43),
            ),
            const SizedBox(height: 8),
            _TenseRow(
              label: 'Future',
              text: cardData['future'] as String,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
          ],
        ),
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
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _TenseRow extends StatelessWidget {
  final String label;
  final String text;
  final Color color;
  const _TenseRow(
      {required this.label, required this.text, required this.color});

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
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
