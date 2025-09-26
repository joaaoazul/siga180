import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../router/navigation_item.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../shared/widgets/sidebar/sidebar_widget.dart';
import '../../shared/widgets/sidebar/bottom_nav.dart';

// Import all screens
import '../../features/athletes/presentation/screens/athletes_screen.dart';
import '../../features/workouts/presentation/screens/workouts_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/scheduling/presentation/screens/scheduling_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/financials/presentation/screens/financials_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: 'dashboard',
    ),
    NavigationItem(
      icon: Icons.people_rounded,
      label: 'Atletas',
      route: 'athletes',
    ),
    NavigationItem(
      icon: Icons.fitness_center_rounded,
      label: 'Treinos',
      route: 'workouts',
    ),
    NavigationItem(
      icon: Icons.restaurant_menu_rounded,
      label: 'Nutrição',
      route: 'nutrition',
    ),
    NavigationItem(
      icon: Icons.calendar_today_rounded,
      label: 'Agenda',
      route: 'schedule',
    ),
    NavigationItem(
      icon: Icons.bar_chart_rounded,
      label: 'Progresso',
      route: 'progress',
    ),
    NavigationItem(
      icon: Icons.attach_money_rounded,
      label: 'Financeiro',
      route: 'financial',
    ),
    NavigationItem(
      icon: Icons.settings_rounded,
      label: 'Configurações',
      route: 'settings',
    ),
  ];

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const AthletesScreen();
      case 2:
        return const WorkoutsScreen();
      case 3:
        return const NutritionScreen();
      case 4:
        return const SchedulingScreen();
      case 5:
        return const ProgressScreen();
      case 6:
        return const FinancialsScreen();
      case 7:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 768;

    if (isMobile) {
      // Mobile Layout with BottomNav
      return Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getPage(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavBar(
          items: _navigationItems,
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
    }

    // Desktop/Tablet Layout with Sidebar
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SidebarWidget(
            items: _navigationItems,
            selectedIndex: _selectedIndex,
            isCollapsed: _isSidebarCollapsed,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            onToggleCollapse: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            onLogout: _handleLogout,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _getPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }
}

class AthletesScreen extends StatelessWidget {
  const AthletesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Athletes Screen')),
    );
  }
}
