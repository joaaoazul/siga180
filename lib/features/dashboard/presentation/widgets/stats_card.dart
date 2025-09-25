import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum StatsCardColor { dark, olive, accent }

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final StatsCardColor color;
  final int? trend;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  Color _getBackgroundColor() {
    switch (color) {
      case StatsCardColor.dark:
        return AppColors.primaryDark;
      case StatsCardColor.olive:
        return AppColors.accent;
      case StatsCardColor.accent:
        return AppColors.primaryOlive;
    }
  }

  Color _getIconColor() {
    switch (color) {
      case StatsCardColor.dark:
      case StatsCardColor.accent:
        return Colors.white;
      case StatsCardColor.olive:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getBackgroundColor().withOpacity(
                    color == StatsCardColor.olive ? 1 : 0.1
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: _getIconColor(),
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trend! > 0 
                        ? AppColors.success.withOpacity(0.1) 
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trend! > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: trend! > 0 ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${trend!.abs()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: trend! > 0 ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}