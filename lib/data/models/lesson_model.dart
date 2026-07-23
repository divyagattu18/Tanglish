import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.lessonId,
    required super.category,
    required super.englishPhrase,
    required super.teluguPhrase,
    required super.transliteration,
    super.audioUrl,
    required super.order,
  });

  factory LessonModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return LessonModel(
      lessonId: doc.id,
      category: (data['category'] as String?) ?? '',
      englishPhrase: (data['englishPhrase'] as String?) ?? '',
      teluguPhrase: (data['teluguPhrase'] as String?) ?? '',
      transliteration: (data['transliteration'] as String?) ?? '',
      audioUrl: data['audioUrl'] as String?,
      order: (data['order'] as int?) ?? 0,
    );
  }

  factory LessonModel.fromMap(Map<String, dynamic> data, String id) {
    return LessonModel(
      lessonId: id,
      category: (data['category'] as String?) ?? '',
      englishPhrase: (data['englishPhrase'] as String?) ?? '',
      teluguPhrase: (data['teluguPhrase'] as String?) ?? '',
      transliteration: (data['transliteration'] as String?) ?? '',
      audioUrl: data['audioUrl'] as String?,
      order: (data['order'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'category': category,
      'englishPhrase': englishPhrase,
      'teluguPhrase': teluguPhrase,
      'transliteration': transliteration,
      'order': order,
      if (audioUrl != null) 'audioUrl': audioUrl,
    };
  }
}
