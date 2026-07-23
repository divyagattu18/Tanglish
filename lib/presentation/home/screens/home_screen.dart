import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/category_grid.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tanglish',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: authAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Something went wrong. Please restart.')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          final firstName = user.displayName.split(' ').first;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, $firstName!  Welcome back',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ready to learn Telugu today?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.grid_view_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Explore',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pick a topic or tap Flash Cards to practice',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: CategoryGrid(
                      onCategoryTap: (cat) => context.push(
                        '/lesson/${Uri.encodeComponent(cat)}',
                      ),
                      onFlashCardsTap: () => context.push('/flashcard-categories'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/categories'),
                      icon: const Icon(
                        Icons.play_circle_outline_rounded,
                        size: 22,
                      ),
                      label: const Text('Continue Learning'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
