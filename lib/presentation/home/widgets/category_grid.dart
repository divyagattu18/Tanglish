import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class _CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  const _CategoryItem(this.name, this.icon, this.color);
}

const _flashCardsColor = Color(0xFFFC5C7D);

const _items = <_CategoryItem>[
  _CategoryItem('Family', Icons.family_restroom_rounded, AppColors.familyColor),
  _CategoryItem('School', Icons.school_rounded, AppColors.schoolColor),
  _CategoryItem('Playground', Icons.sports_soccer_rounded, AppColors.playgroundColor),
  _CategoryItem('Food', Icons.restaurant_rounded, AppColors.foodColor),
  _CategoryItem('Daily Activities', Icons.wb_sunny_rounded, AppColors.dailyColor),
  _CategoryItem('Flash Cards', Icons.style_rounded, _flashCardsColor),
];

class CategoryGrid extends StatelessWidget {
  final void Function(String category) onCategoryTap;
  final VoidCallback onFlashCardsTap;

  const CategoryGrid({super.key, required this.onCategoryTap, required this.onFlashCardsTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossCount = 2;
        const rowCount = 3; // ceil(5 / 2)
        const spacing = 10.0;
        final tileH =
            (constraints.maxHeight - (rowCount - 1) * spacing) / rowCount;
        final tileW =
            (constraints.maxWidth - (crossCount - 1) * spacing) / crossCount;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: tileW / tileH,
          ),
          itemCount: _items.length,
          itemBuilder: (context, i) {
            final item = _items[i];
            return _CategoryCard(
              item: item,
              onTap: item.name == 'Flash Cards'
                  ? onFlashCardsTap
                  : () => onCategoryTap(item.name),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  final VoidCallback onTap;

  const _CategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.18),
                item.color.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.color.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 34, color: item.color),
              const SizedBox(height: 6),
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: item.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
