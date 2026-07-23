import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/progress_repository_impl.dart';
import '../domain/entities/progress_entity.dart';
import '../domain/repositories/progress_repository.dart';
import '../domain/usecases/get_user_progress_usecase.dart';
import '../domain/usecases/mark_lesson_complete_usecase.dart';
import 'auth_provider.dart';
import 'lesson_provider.dart';

// ── Infrastructure ────────────────────────────────────────────────────────

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(ref.watch(firestoreDataSourceProvider));
});

// ── Use cases ─────────────────────────────────────────────────────────────

final markLessonCompleteUseCaseProvider =
    Provider<MarkLessonCompleteUseCase>((ref) {
  return MarkLessonCompleteUseCase(ref.watch(progressRepositoryProvider));
});

final getUserProgressUseCaseProvider =
    Provider<GetUserProgressUseCase>((ref) {
  return GetUserProgressUseCase(ref.watch(progressRepositoryProvider));
});

// ── Streams ───────────────────────────────────────────────────────────────

/// Real-time stream of the current user's progress documents.
final userProgressProvider = StreamProvider<List<ProgressEntity>>((ref) {
  final authAsync = ref.watch(authStateProvider);
  return authAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref
          .watch(progressRepositoryProvider)
          .watchUserProgress(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

/// Set of completed lesson IDs for fast lookup.
final completedLessonIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(userProgressProvider).maybeWhen(
        data: (list) =>
            list.where((p) => p.completed).map((p) => p.lessonId).toSet(),
        orElse: () => {},
      );
});

/// Returns true if [lessonId] has been completed.
final isLessonCompletedProvider =
    Provider.family<bool, String>((ref, lessonId) {
  return ref.watch(completedLessonIdsProvider).contains(lessonId);
});

// ── Stats ─────────────────────────────────────────────────────────────────

class ProgressStats {
  final int completedCount;
  const ProgressStats({required this.completedCount});
}

final progressStatsProvider = Provider<ProgressStats>((ref) {
  final count = ref.watch(userProgressProvider).maybeWhen(
        data: (list) => list.where((p) => p.completed).length,
        orElse: () => 0,
      );
  return ProgressStats(completedCount: count);
});

// ── Lesson complete notifier ──────────────────────────────────────────────

class LessonCompleteNotifier extends StateNotifier<AsyncValue<void>> {
  final MarkLessonCompleteUseCase _useCase;

  LessonCompleteNotifier(this._useCase) : super(const AsyncValue.data(null));

  Future<void> markComplete({
    required String uid,
    required String lessonId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _useCase(
        ProgressEntity(
          uid: uid,
          lessonId: lessonId,
          completed: true,
          score: 100,
          completedDate: DateTime.now(),
        ),
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final lessonCompleteNotifierProvider =
    StateNotifierProvider<LessonCompleteNotifier, AsyncValue<void>>((ref) {
  return LessonCompleteNotifier(
    ref.watch(markLessonCompleteUseCaseProvider),
  );
});
