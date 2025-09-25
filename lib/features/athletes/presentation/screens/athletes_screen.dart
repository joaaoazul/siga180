import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/athlete_model.dart';
import '../../../../core/services/auth_service.dart';
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
          Text(
            'Atletas',
            style: GoogleFonts.poppins(
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
                ),
                SlidableAction(
                  onPressed: (_) => _deleteAthlete(athlete),
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Apagar',
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
          Text(
            'Sem atletas',
            style: GoogleFonts.poppins(
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
          athlete.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
  }
  
  void _deleteAthlete(Athlete athlete) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('Apagar ${athlete.name}?'),
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
    
    if (confirmed == true) {
      final service = ref.read(athletesServiceProvider);
      await service.deleteAthlete(athlete.id);
    }
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOlive, AppColors.accent],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                athlete.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  athlete.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (athlete.email != null)
                  Text(
                    athlete.email!,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 14,
                    ),
                  ),
                if (athlete.phone != null)
                  Text(
                    athlete.phone!,
                    style: const TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          _StatusBadge(status: athlete.status),
        ],
      ),
    );
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
      ),
      child: Text(
        isActive ? 'Ativo' : 'Inativo',
        style: TextStyle(
          color: isActive ? AppColors.success : AppColors.lightGray,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
