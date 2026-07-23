import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/sign_in_with_apple_usecase.dart';
import '../domain/usecases/sign_in_with_google_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';

// ── Dev bypass ────────────────────────────────────────────────────────────
// Set to true to skip login and jump straight into the app for testing.
// IMPORTANT: set back to false before shipping.
const kBypassLogin = true;

// ── Infrastructure ────────────────────────────────────────────────────────

final _firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final _googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn(),
);

final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(_firebaseAuthProvider),
    googleSignIn: ref.watch(_googleSignInProvider),
  );
});

final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(_authRemoteDataSourceProvider));
});

// ── Use cases ─────────────────────────────────────────────────────────────

final _signInWithGoogleProvider = Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.watch(_authRepositoryProvider));
});

final _signInWithAppleProvider = Provider<SignInWithAppleUseCase>((ref) {
  return SignInWithAppleUseCase(ref.watch(_authRepositoryProvider));
});

final _signOutProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(_authRepositoryProvider));
});

// ── Auth state stream ─────────────────────────────────────────────────────

/// Reactive stream of the current authenticated user (null = signed out).
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  if (kBypassLogin) {
    // Return a fake user immediately — no Firebase call, no login screen.
    return Stream.value(UserEntity(
      uid: 'dev-user-001',
      displayName: 'Buddy',
      email: 'test@tanglish.dev',
      createdAt: DateTime(2024, 1, 1),
      streak: 3,
      xp: 120,
    ));
  }
  return ref.watch(_authRepositoryProvider).authStateChanges;
});

// ── Auth notifier ─────────────────────────────────────────────────────────

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithGoogleUseCase _google;
  final SignInWithAppleUseCase _apple;
  final SignOutUseCase _signOut;

  AuthNotifier({
    required SignInWithGoogleUseCase google,
    required SignInWithAppleUseCase apple,
    required SignOutUseCase signOut,
  })  : _google = google,
        _apple = apple,
        _signOut = signOut,
        super(const AuthState());

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _google();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: _friendly(e),
      );
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _apple();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: _friendly(e),
      );
    }
  }

  Future<void> signOut() async {
    await _signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Sanitise error messages — never expose internal details to the UI.
  String _friendly(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Network error. Please check your connection.';
    }
    if (msg.contains('cancel') || msg.contains('abort')) {
      return 'Sign-in was cancelled.';
    }
    if (msg.contains('credential')) {
      return 'Sign-in failed. Please try a different account.';
    }
    return 'Sign-in failed. Please try again.';
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    google: ref.watch(_signInWithGoogleProvider),
    apple: ref.watch(_signInWithAppleProvider),
    signOut: ref.watch(_signOutProvider),
  );
});
