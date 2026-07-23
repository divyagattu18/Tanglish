import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/firestore_datasource.dart';
import '../data/models/lesson_model.dart';
import '../data/repositories/lesson_repository_impl.dart';
import '../data/seed/lesson_seed_data.dart';
import '../domain/entities/lesson_entity.dart';
import '../domain/repositories/lesson_repository.dart';
import '../domain/usecases/get_lessons_by_category_usecase.dart';
import 'auth_provider.dart';

// ── Infrastructure ────────────────────────────────────────────────────────

final firestoreDataSourceProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSourceImpl();
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepositoryImpl(ref.watch(firestoreDataSourceProvider));
});

// ── Use cases ─────────────────────────────────────────────────────────────

final getLessonsByCategoryUseCaseProvider =
    Provider<GetLessonsByCategoryUseCase>((ref) {
  return GetLessonsByCategoryUseCase(ref.watch(lessonRepositoryProvider));
});

// ── Lessons by category ───────────────────────────────────────────────────

/// Fetches lessons for [category]; auto-seeds Firestore on empty results.
final lessonsByCategoryProvider =
    FutureProvider.family<List<LessonEntity>, String>((ref, category) async {
  // Dev bypass: serve in-memory seed data, no Firestore needed.
  if (kBypassLogin) {
    return lessonSeedData
        .where((m) => m['category'] == category)
        .map((m) => LessonModel.fromMap(m, m['lessonId'] as String))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  final useCase = ref.watch(getLessonsByCategoryUseCaseProvider);
  final lessons = await useCase(category);

  if (lessons.isEmpty) {
    // Seed data on first run (idempotent — skips existing docs)
    await ref
        .read(firestoreDataSourceProvider)
        .seedLessons(lessonSeedData);
    return useCase(category);
  }

  return lessons;
});

// ── Seed ──────────────────────────────────────────────────────────────────

/// Idempotent seed operation; safe to call multiple times.
final seedLessonsProvider = FutureProvider<void>((ref) async {
  await ref
      .read(firestoreDataSourceProvider)
      .seedLessons(lessonSeedData);
});
