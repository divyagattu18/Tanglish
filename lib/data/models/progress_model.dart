import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/progress_entity.dart';

class ProgressModel extends ProgressEntity {
  const ProgressModel({
    required super.uid,
    required super.lessonId,
    required super.completed,
    required super.score,
    required super.completedDate,
  });

  factory ProgressModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ProgressModel(
      uid: (data['uid'] as String?) ?? '',
      lessonId: (data['lessonId'] as String?) ?? '',
      completed: (data['completed'] as bool?) ?? false,
      score: (data['score'] as int?) ?? 0,
      completedDate:
          (data['completedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ProgressModel.fromEntity(ProgressEntity entity) {
    return ProgressModel(
      uid: entity.uid,
      lessonId: entity.lessonId,
      completed: entity.completed,
      score: entity.score,
      completedDate: entity.completedDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'lessonId': lessonId,
      'completed': completed,
      'score': score,
      'completedDate': Timestamp.fromDate(completedDate),
    };
  }
}
