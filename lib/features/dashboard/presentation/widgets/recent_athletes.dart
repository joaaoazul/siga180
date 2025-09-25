import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class RecentAthletes extends StatelessWidget {
  final AsyncValue<List<Map<String, dynamic>>> athletesAsync;

  const RecentAthletes({super.key, required this.athletesAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Atletas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Ver todos'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryOlive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          athletesAsync.when(
            data: (athletes) {
              if (athletes.isEmpty) {
                return _buildEmptyState();
              }
              return Column(
                children: [
                  ...athletes
                      .take(5)
                      .map((athlete) => _AthleteListItem(athlete: athlete)),
                  const SizedBox(height: 24),
                  _buildAddButton(),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => Text('Erro: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.people_rounded, size: 48, color: Colors.grey[300]),
        const SizedBox(height: 12),
        const Text(
          'Ainda sem atletas',
          style: TextStyle(color: AppColors.lightGray),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Adicionar Primeiro Atleta'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOlive,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.person_add, size: 18),
        label: const Text('Adicionar Novo Atleta'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _AthleteListItem extends StatelessWidget {
  final Map<String, dynamic> athlete;

  const _AthleteListItem({required this.athlete});

  @override
  Widget build(BuildContext context) {
    final name = athlete['name'] ?? 'Sem nome';
    final status = athlete['status'] ?? 'active';
    final isActive = status == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.textGray],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.lightGray.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isActive ? 'Ativo' : 'Inativo',
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppColors.success : AppColors.lightGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
