import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/athlete_model.dart';
import '../../data/services/athletes_service.dart';
import '../widgets/add_athlete_dialog.dart';

final athletesServiceProvider = Provider((ref) => AthletesService());

final athletesStreamProvider = StreamProvider<List<Athlete>>((ref) {
  final service = ref.watch(athletesServiceProvider);
  return service.getAthletes();
});

class AthletesScreen extends ConsumerStatefulWidget {
  const AthletesScreen({super.key});

  @override
  ConsumerState<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends ConsumerState<AthletesScreen> {
  String _searchQuery = '';
  String _filterStatus = 'all';
  
  @override
  Widget build(BuildContext context) {
    final athletesAsync = ref.watch(athletesStreamProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          Expanded(
            child: athletesAsync.when(
              data: (athletes) {
                final filtered = _filterAthletes(athletes);
                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildAthletesList(filtered);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Erro: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAthleteDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Atleta'),
        backgroundColor: AppColors.primaryOlive,
        foregroundColor: Colors.white,
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atletas',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gerir e acompanhar os seus atletas',
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar atletas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryOlive, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _filterStatus,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Todos')),
                DropdownMenuItem(value: 'active', child: Text('Ativos')),
                DropdownMenuItem(value: 'inactive', child: Text('Inativos')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAthletesList(List<Athlete> athletes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: athletes.length,
      itemBuilder: (context, index) {
        final athlete = athletes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _editAthlete(athlete),
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Editar',
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                SlidableAction(
                  onPressed: (_) => _deleteAthlete(athlete),
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Apagar',
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ],
            ),
            child: _AthleteCard(athlete: athlete),
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sem atletas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione o seu primeiro atleta para começar',
            style: TextStyle(color: AppColors.lightGray),
          ),
        ],
      ),
    );
  }
  
  List<Athlete> _filterAthletes(List<Athlete> athletes) {
    return athletes.where((athlete) {
      final matchesSearch = _searchQuery.isEmpty ||
          athlete.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (athlete.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final matchesFilter = _filterStatus == 'all' ||
          athlete.status == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();
  }
  
  void _showAddAthleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAthleteDialog(),
    );
  }
  
  void _editAthlete(Athlete athlete) {
    // TODO: Implementar edição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar ${athlete.name} - Em desenvolvimento'),
        backgroundColor: AppColors.info,
      ),
    );
  }
  
  void _deleteAthlete(Athlete athlete) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('Tem certeza que deseja apagar ${athlete.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      try {
        final service = ref.read(athletesServiceProvider);
        await service.deleteAthlete(athlete.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Atleta removido com sucesso'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao remover atleta: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

class AddAthleteDialog extends StatelessWidget {
  const AddAthleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the actual dialog UI
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Center(
        child: Text(
          'Adicionar Atleta (Em desenvolvimento)',
          style: TextStyle(fontSize: 18, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}

class _AthleteCard extends StatelessWidget {
  final Athlete athlete;
  
  const _AthleteCard({required this.athlete});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOlive, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                athlete.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  athlete.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (athlete.email != null && athlete.email!.isNotEmpty)
                  Text(
                    athlete.email!,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (athlete.phone != null && athlete.phone!.isNotEmpty) ...[
                      Icon(Icons.phone, size: 14, color: AppColors.lightGray),
                      const SizedBox(width: 4),
                      Text(
                        athlete.phone!,
                        style: const TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (athlete.age != null) ...[
                      Icon(Icons.cake, size: 14, color: AppColors.lightGray),
                      const SizedBox(width: 4),
                      Text(
                        '${athlete.age} anos',
                        style: const TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Status Badge & Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusBadge(status: athlete.status),
              const SizedBox(height: 8),
              if (athlete.goal.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOlive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getGoalLabel(athlete.goal),
                    style: TextStyle(
                      color: AppColors.primaryOlive,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getGoalLabel(String goal) {
    switch (goal) {
      case 'muscle_gain':
        return 'Ganho Muscular';
      case 'fat_loss':
        return 'Perda de Gordura';
      case 'maintenance':
        return 'Manutenção';
      case 'performance':
        return 'Performance';
      case 'endurance':
        return 'Resistência';
      case 'strength':
        return 'Força';
      default:
        return 'Geral';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  
  const _StatusBadge({required this.status});
  
  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withOpacity(0.1)
            : AppColors.lightGray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.success.withOpacity(0.3)
              : AppColors.lightGray.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.success : AppColors.lightGray,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Ativo' : 'Inativo',
            style: TextStyle(
              color: isActive ? AppColors.success : AppColors.lightGray,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}