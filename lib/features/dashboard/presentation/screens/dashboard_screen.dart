// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../widgets/stats_card.dart';
import '../widgets/today_sessions.dart';
import '../widgets/recent_athletes.dart';
import '../widgets/quick_actions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athletesAsync = ref.watch(athletesStreamProvider);
    final user = Supabase.instance.client.auth.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user),
            const SizedBox(height: 32),
            _buildStatsGrid(athletesAsync),
            const SizedBox(height: 32),
            _buildContentGrid(context, athletesAsync),
            const SizedBox(height: 24),
            const QuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    final now = DateTime.now();
    final formatter = DateFormat.yMMMMEEEEd('pt_PT');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${user?.email?.split('@')[0] ?? 'Trainer'} 👋',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(now),
          style: const TextStyle(
            color: AppColors.textGray,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(AsyncValue<List<Map<String, dynamic>>> athletesAsync) {
    return athletesAsync.when(
      data: (athletes) {
        final stats = _calculateStats(athletes);
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1200 ? 4 : 
                                   constraints.maxWidth > 768 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: constraints.maxWidth > 768 ? 1.5 : 2.5,
              children: [
                StatsCard(
                  icon: Icons.people_rounded,
                  label: 'Total de Atletas',
                  value: '${stats['total']}',
                  color: StatsCardColor.dark,
                ),
                StatsCard(
                  icon: Icons.show_chart_rounded,
                  label: 'Atletas Ativos',
                  value: '${stats['active']}',
                  color: StatsCardColor.olive,
                  trend: 12,
                ),
                StatsCard(
                  icon: Icons.event_rounded,
                  label: 'Sessões Hoje',
                  value: '3',
                  color: StatsCardColor.accent,
                ),
                StatsCard(
                  icon: Icons.emoji_events_rounded,
                  label: 'Novos Este Mês',
                  value: '${stats['new']}',
                  color: StatsCardColor.olive,
                  trend: 8,
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildContentGrid(BuildContext context, AsyncValue<List<Map<String, dynamic>>> athletesAsync) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: TodaysSessions(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: RecentAthletes(athletesAsync: athletesAsync),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const TodaysSessions(),
              const SizedBox(height: 24),
              RecentAthletes(athletesAsync: athletesAsync),
            ],
          );
        }
      },
    );
  }

  Map<String, int> _calculateStats(List<Map<String, dynamic>> athletes) {
    final now = DateTime.now();
    return {
      'total': athletes.length,
      'active': athletes.where((a) => a['status'] == 'active').length,
      'new': athletes.where((a) {
        final created = DateTime.tryParse(a['created_at'] ?? '');
        if (created == null) return false;
        return created.month == now.month && created.year == now.year;
      }).length,
    };
  }
}