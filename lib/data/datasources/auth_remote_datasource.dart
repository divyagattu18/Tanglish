import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _fetchOrCreateUser(user);
    });
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign-in was cancelled.');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return _fetchOrCreateUser(result.user!);
  }

  @override
  Future<UserModel> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final result = await _auth.signInWithCredential(oauthCredential);
    final user = result.user!;

    // Set display name from Apple on first sign-in
    if (user.displayName == null &&
        appleCredential.givenName != null) {
      final fullName =
          '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
              .trim();
      await user.updateDisplayName(fullName);
      await user.reload();
    }

    return _fetchOrCreateUser(_auth.currentUser!);
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fetchOrCreateUser(result.user!);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _fetchOrCreateUser(user);
  }

  // ── Private helpers ───────────────────────────────────────────────────

  Future<UserModel> _fetchOrCreateUser(User user) async {
    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data()!,
          toFirestore: (data, _) => data,
        );

    final snap = await _firestore.collection('users').doc(user.uid).get();

    if (!snap.exists) {
      final model = UserModel(
        uid: user.uid,
        displayName: user.displayName ?? 'Learner',
        email: user.email ?? '',
        createdAt: DateTime.now(),
        streak: 0,
        xp: 0,
        photoUrl: user.photoURL,
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(model.toFirestore());
      return model;
    }

    return UserModel.fromFirestore(
      snap as DocumentSnapshot<Map<String, dynamic>>,
    );
  }

  /// Cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final rng = Random.secure();
    return List.generate(length, (_) => charset[rng.nextInt(charset.length)])
        .join();
  }

  String _sha256(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
