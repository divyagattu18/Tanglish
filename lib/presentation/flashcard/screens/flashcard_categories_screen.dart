import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class FlashcardCategoriesScreen extends StatelessWidget {
  const FlashcardCategoriesScreen({super.key});

  static const _categories = [
    _FlashCategory('Family', Icons.family_restroom_rounded, AppColors.familyColor),
    _FlashCategory('School', Icons.school_rounded, AppColors.schoolColor),
    _FlashCategory('Playground', Icons.sports_soccer_rounded, AppColors.playgroundColor),
    _FlashCategory('Food', Icons.restaurant_rounded, AppColors.foodColor),
    _FlashCategory('Daily Activities', Icons.wb_sunny_rounded, AppColors.dailyColor),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Cards'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a category',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Flip cards to learn Telugu words',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return _CategoryTile(
                      category: cat,
                      onTap: () => context.push(
                        '/flashcards/${Uri.encodeComponent(cat.name)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashCategory {
  final String name;
  final IconData icon;
  final Color color;
  const _FlashCategory(this.name, this.icon, this.color);
}

class _CategoryTile extends StatelessWidget {
  final _FlashCategory category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                category.color.withOpacity(0.18),
                category.color.withOpacity(0.06),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: category.color.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: category.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: category.color,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: category.color.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
