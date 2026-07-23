import 'package:flutter/material.dart';

class XpCard extends StatelessWidget {
  final int xp;
  const XpCard({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4A900);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD93D).withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 28, color: Color(0xFFD4A900)),
          const SizedBox(height: 4),
          Text(
            '$xp',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: gold,
            ),
          ),
          Text(
            'XP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: gold.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
