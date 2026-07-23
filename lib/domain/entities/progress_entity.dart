import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final String uid;
  final String lessonId;
  final bool completed;
  final int score;
  final DateTime completedDate;

  const ProgressEntity({
    required this.uid,
    required this.lessonId,
    required this.completed,
    required this.score,
    required this.completedDate,
  });

  @override
  List<Object?> get props => [uid, lessonId, completed, score, completedDate];
}
