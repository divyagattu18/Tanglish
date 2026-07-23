import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StreakCard extends StatelessWidget {
  final int streak;
  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded, size: 28, color: AppColors.secondary),
          const SizedBox(height: 4),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          Text(
            'Streak',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
