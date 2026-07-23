import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../providers/progress_provider.dart';
import '../widgets/audio_play_button.dart';
import '../widgets/phrase_card.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String category;
  const LessonScreen({super.key, required this.category});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _index = 0;
  final _player = AudioPlayer();
  bool _playing = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio coming soon!')),
      );
      return;
    }
    try {
      setState(() => _playing = true);
      await _player.setUrl(url);
      await _player.play();
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  Future<void> _markComplete(String lessonId) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return;

    await ref
        .read(lessonCompleteNotifierProvider.notifier)
        .markComplete(uid: user.uid, lessonId: lessonId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson complete! +10 XP 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync =
        ref.watch(lessonsByCategoryProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: lessonsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 52, color: AppColors.error),
              const SizedBox(height: 16),
              const Text('Failed to load lessons.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(
                  lessonsByCategoryProvider(widget.category),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (lessons) {
          if (lessons.isEmpty) {
            return const Center(
              child: Text(
                'No lessons yet.\nCheck back soon!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Clamp index in case lessons list shrinks
          final safeIndex = _index.clamp(0, lessons.length - 1);
          final lesson = lessons[safeIndex];
          final total = lessons.length;
          final isCompleted =
              ref.watch(isLessonCompletedProvider(lesson.lessonId));

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress
                  Row(
                    children: [
                      Text(
                        '${safeIndex + 1} / $total',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (safeIndex + 1) / total,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceColor,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Phrase card
                  Expanded(
                    child: PhraseCard(
                      englishPhrase: lesson.englishPhrase,
                      teluguPhrase: lesson.teluguPhrase,
                      transliteration: lesson.transliteration,
                      isCompleted: isCompleted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Audio
                  AudioPlayButton(
                    isPlaying: _playing,
                    onTap: () => _play(lesson.audioUrl),
                  ),
                  const SizedBox(height: 16),
                  // Complete / done badge
                  if (!isCompleted)
                    ElevatedButton.icon(
                      onPressed: () =>
                          _markComplete(lesson.lessonId),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: const Size(double.infinity, 54),
                      ),
                    )
                  else
                    _CompletedBadge(),
                  const SizedBox(height: 12),
                  // Navigation
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: safeIndex > 0
                              ? () => setState(() => _index = safeIndex - 1)
                              : null,
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: safeIndex < total - 1
                              ? () => setState(
                                  () => _index = safeIndex + 1)
                              : () => context.pop(),
                          child: Text(
                            safeIndex < total - 1 ? 'Next' : 'Finish',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success, width: 1.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success),
          SizedBox(width: 8),
          Text(
            'Completed!',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
