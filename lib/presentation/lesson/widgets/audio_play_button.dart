import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AudioPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioPlayButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tooltip(
        message: 'Play pronunciation',
        child: GestureDetector(
          onTap: isPlaying ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPlaying
                  ? AppColors.primary.withOpacity(0.7)
                  : AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: isPlaying
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),
      ),
    );
  }
}
