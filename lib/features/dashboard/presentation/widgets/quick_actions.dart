import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 768 ? 3 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3,
          children: [
            _QuickActionButton(
              icon: Icons.fitness_center_rounded,
              label: 'Criar Treino',
              onPressed: () {},
            ),
            _QuickActionButton(
              icon: Icons.restaurant_rounded,
              label: 'Planos Nutrição',
              onPressed: () {},
            ),
            _QuickActionButton(
              icon: Icons.bar_chart_rounded,
              label: 'Análises',
              onPressed: () {},
            ),
            _QuickActionButton(
              icon: Icons.calendar_today_rounded,
              label: 'Agendar',
              onPressed: () {},
            ),
            _QuickActionButton(
              icon: Icons.assessment_rounded,
              label: 'Relatórios',
              onPressed: () {},
            ),
            _QuickActionButton(
              icon: Icons.video_library_rounded,
              label: 'Vídeos',
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.lightGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
