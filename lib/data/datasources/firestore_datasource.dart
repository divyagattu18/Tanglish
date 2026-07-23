import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/progress_entity.dart';
import '../models/lesson_model.dart';
import '../models/progress_model.dart';

abstract class FirestoreDataSource {
  Future<List<LessonModel>> getLessonsByCategory(String category);
  Future<List<String>> getCategories();
  Future<LessonModel?> getLessonById(String lessonId);
  Future<List<ProgressModel>> getUserProgress(String uid);
  Future<void> markLessonComplete(ProgressEntity progress);
  Future<bool> isLessonCompleted(String uid, String lessonId);
  Stream<List<ProgressModel>> watchUserProgress(String uid);
  Future<void> seedLessons(List<Map<String, dynamic>> lessons);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _db;

  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<LessonModel>> getLessonsByCategory(String category) async {
    final snap = await _db
        .collection('lessons')
        .where('category', isEqualTo: category)
        .orderBy('order')
        .get();

    return snap.docs
        .map((doc) => LessonModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final snap = await _db.collection('lessons').get();
    return snap.docs
        .map((d) => (d.data()['category'] as String?) ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Future<LessonModel?> getLessonById(String lessonId) async {
    final doc = await _db.collection('lessons').doc(lessonId).get();
    if (!doc.exists) return null;
    return LessonModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  @override
  Future<List<ProgressModel>> getUserProgress(String uid) async {
    final snap = await _db
        .collection('progress')
        .where('uid', isEqualTo: uid)
        .where('completed', isEqualTo: true)
        .get();

    return snap.docs
        .map((doc) => ProgressModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  @override
  Future<void> markLessonComplete(ProgressEntity progress) async {
    // Composite doc ID prevents duplicate progress entries
    final docId = '${progress.uid}_${progress.lessonId}';
    final model = ProgressModel.fromEntity(progress);

    final batch = _db.batch();

    // Write progress document
    batch.set(
      _db.collection('progress').doc(docId),
      model.toFirestore(),
      SetOptions(merge: true),
    );

    // Increment XP on user document
    batch.update(
      _db.collection('users').doc(progress.uid),
      {'xp': FieldValue.increment(10)},
    );

    await batch.commit();
  }

  @override
  Future<bool> isLessonCompleted(String uid, String lessonId) async {
    final docId = '${uid}_$lessonId';
    final doc = await _db.collection('progress').doc(docId).get();
    return doc.exists && ((doc.data()?['completed'] as bool?) ?? false);
  }

  @override
  Stream<List<ProgressModel>> watchUserProgress(String uid) {
    return _db
        .collection('progress')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ProgressModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  @override
  Future<void> seedLessons(List<Map<String, dynamic>> lessons) async {
    final batch = _db.batch();
    for (final lesson in lessons) {
      final id = lesson['lessonId'] as String;
      final ref = _db.collection('lessons').doc(id);
      final existing = await ref.get();
      if (!existing.exists) {
        batch.set(ref, lesson);
      }
    }
    await batch.commit();
  }
}
