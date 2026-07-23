import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final DateTime createdAt;
  final int streak;
  final int xp;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.streak = 0,
    this.xp = 0,
    this.photoUrl,
  });

  UserEntity copyWith({
    String? displayName,
    int? streak,
    int? xp,
    String? photoUrl,
  }) {
    return UserEntity(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      createdAt: createdAt,
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, streak, xp, photoUrl];
}
