import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final String lessonId;
  final String category;
  final String englishPhrase;
  final String teluguPhrase;
  final String transliteration;
  final String? audioUrl;
  final int order;

  const LessonEntity({
    required this.lessonId,
    required this.category,
    required this.englishPhrase,
    required this.teluguPhrase,
    required this.transliteration,
    this.audioUrl,
    required this.order,
  });

  @override
  List<Object?> get props =>
      [lessonId, category, englishPhrase, teluguPhrase, transliteration, order];
}
