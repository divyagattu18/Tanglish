import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/seed/flashcard_seed_data.dart';
import '../widgets/flip_card_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final String category;
  const FlashcardScreen({super.key, required this.category});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // Difficulty filter: 'All' | 'Beginner' | 'Intermediate' | 'Advanced'
  String _difficulty = 'All';
  int _index = 0;
  bool _isFlipped = false;

  List<Map<String, dynamic>> get _cards {
    final all = _seedForCategory(widget.category);
    if (_difficulty == 'All') return all;
    return all.where((c) => c['difficulty'] == _difficulty).toList();
  }

  static List<Map<String, dynamic>> _seedForCategory(String category) {
    // Extend here when more categories get flashcard data
    switch (category) {
      case 'Family':
        return familyFlashcards;
      default:
        return familyFlashcards; // fallback until other categories are seeded
    }
  }

  void _goNext() {
    final cards = _cards;
    if (_index < cards.length - 1) {
      setState(() {
        _index++;
        _isFlipped = false;
      });
    }
  }

  void _goPrev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _isFlipped = false;
      });
    }
  }

  void _setDifficulty(String d) {
    setState(() {
      _difficulty = d;
      _index = 0;
      _isFlipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = _cards;
    final isEmpty = cards.isEmpty;
    final card = isEmpty ? null : cards[_index];
    final total = cards.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('${widget.category} Flashcards'),
        actions: [
          if (!isEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_index + 1} / $total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar ───────────────────────────────────────────
            if (!isEmpty)
              LinearProgressIndicator(
                value: (_index + 1) / total,
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),

            // ── Difficulty filter chips ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['All', 'Beginner', 'Intermediate', 'Advanced'].map((d) {
                    final selected = _difficulty == d;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _setDifficulty(d),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Card or empty state ────────────────────────────────────
            Expanded(
              child: isEmpty
                  ? _EmptyState(difficulty: _difficulty)
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: FlipCardWidget(
                        key: ValueKey(card!['id'] as String),
                        cardData: card,
                        isFlipped: _isFlipped,
                        onFlip: () =>
                            setState(() => _isFlipped = !_isFlipped),
                      ),
                    ),
            ),

            // ── Navigation ────────────────────────────────────────────
            if (!isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _index > 0 ? _goPrev : null,
                        icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 16),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _index < total - 1 ? _goNext : _onFinish,
                        icon: Icon(
                          _index < total - 1
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.emoji_events_rounded,
                          size: 16,
                        ),
                        label: Text(
                            _index < total - 1 ? 'Next' : 'Finish!'),
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onFinish() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.emoji_events_rounded,
              color: AppColors.accent, size: 28),
          SizedBox(width: 8),
          Text('Well done!'),
        ]),
        content: Text(
          'You reviewed all ${_cards.length} ${widget.category} flashcards!\n\n'
          'Keep practising to remember them better.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _index = 0;
                _isFlipped = false;
              });
            },
            child: const Text('Start Over'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String difficulty;
  const _EmptyState({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list_off_rounded,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No $difficulty cards yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different difficulty filter',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
