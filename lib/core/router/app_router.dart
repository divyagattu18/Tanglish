import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/flashcard/screens/flashcard_categories_screen.dart';
import '../../presentation/flashcard/screens/flashcard_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/lesson/screens/categories_screen.dart';
import '../../presentation/lesson/screens/lesson_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnLogin = state.matchedLocation == '/login';

      // Stay on splash while loading or during animation
      if (isOnSplash) return null;
      if (isLoading) return '/splash';

      final isAuthenticated = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      if (!isAuthenticated && !isOnLogin) return '/login';
      if (isAuthenticated && isOnLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/lesson/:category',
        builder: (context, state) {
          final raw = state.pathParameters['category'] ?? '';
          final category = Uri.decodeComponent(raw);
          return LessonScreen(category: category);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/flashcard-categories',
        builder: (context, state) => const FlashcardCategoriesScreen(),
      ),
      GoRoute(
        path: '/flashcards/:category',
        builder: (context, state) {
          final raw = state.pathParameters['category'] ?? '';
          final category = Uri.decodeComponent(raw);
          return FlashcardScreen(category: category);
        },
      ),
    ],
  );
});
