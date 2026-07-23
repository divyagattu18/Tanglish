import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.displayName,
    required super.email,
    required super.createdAt,
    super.streak,
    super.xp,
    super.photoUrl,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      displayName: (data['displayName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      streak: (data['streak'] as int?) ?? 0,
      xp: (data['xp'] as int?) ?? 0,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      displayName: entity.displayName,
      email: entity.email,
      createdAt: entity.createdAt,
      streak: entity.streak,
      xp: entity.xp,
      photoUrl: entity.photoUrl,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'streak': streak,
      'xp': xp,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
