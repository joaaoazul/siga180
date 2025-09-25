import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TodaysSessions extends StatelessWidget {
  const TodaysSessions({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - substituir por dados reais
    final sessions = [
      {
        'id': 1,
        'athlete': {'name': 'João Silva'},
        'time': '14:00',
        'duration': '1h',
        'type': 'Treino de Força'
      },
      {
        'id': 2,
        'athlete': {'name': 'Maria Santos'},
        'time': '15:00',
        'duration': '1h',
        'type': 'Cardio'
      },
      {
        'id': 3,
        'athlete': {'name': 'Pedro Costa'},
        'time': '16:00',
        'duration': '1h',
        'type': 'Funcional'
      },
    ];

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
                'Sessões de Hoje',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to sessions
                },
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Ver todas'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryOlive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (sessions.isEmpty)
            _buildEmptyState()
          else
            ...sessions.map((session) => SessionCard(session: session)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 48,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sem sessões agendadas para hoje',
          style: TextStyle(color: AppColors.lightGray),
        ),
      ],
    );
  }
}

class SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final athleteName = session['athlete']['name'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOlive, AppColors.accent],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                athleteName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  athleteName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  session['type'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  session['time'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                session['duration'],
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}