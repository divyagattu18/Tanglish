import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/progress_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final stats = ref.watch(progressStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: authAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Error loading profile.')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 52,
                    backgroundColor:
                        AppColors.primary.withOpacity(0.12),
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 38,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  // Stats
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: 'Streak',
                        value: '${user.streak}',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.secondary,
                      ),
                      _StatItem(
                        label: 'XP',
                        value: '${user.xp}',
                        icon: Icons.star_rounded,
                        color: const Color(0xFFD4A900),
                      ),
                      _StatItem(
                        label: 'Lessons',
                        value: '${stats.completedCount}',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  // Sign out
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.error),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: color),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
