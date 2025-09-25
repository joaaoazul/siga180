import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar localização PT
  await initializeDateFormatting('pt_PT', null);
  
  // Status bar transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Inicializar Supabase com as tuas credenciais
  await Supabase.initialize(
    url: 'https://dexrcuozaparpjyienxp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRleHJjdW96YXBhcnBqeWllbnhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTg0MzksImV4cCI6MjA3MDA3NDQzOX0._igJJrA-jple4Wfyq2GAUF8jdABVNUGdMPrxCrYQmxM',
  );
  
  runApp(
    const ProviderScope(
      child: Siga180App(),
    ),
  );
}

// ================================================
// APP THEME - CORES EXATAS DO REACT
// ================================================
class AppColors {
  static const Color primaryDark = Color(0xFF333333);
  static const Color primaryOlive = Color(0xFF6B8E23);
  static const Color accent = Color(0xFFE8ECE3);
  static const Color background = Color(0xFFF9FAFB); // gray-50
  static const Color cardBorder = Color(0xFFE5E7EB); // gray-200
  static const Color textGray = Color(0xFF6B7280); // gray-600
  static const Color lightGray = Color(0xFF9CA3AF); // gray-500
  static const Color white = Colors.white;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

class Siga180App extends StatelessWidget {
  const Siga180App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGA180',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primaryDark),
          titleTextStyle: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOlive,
          background: AppColors.background,
        ),
      ),
      home: const AuthCheck(),
    );
  }
}

// ================================================
// AUTH CHECK
// ================================================
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null ? const MainLayout() : const LoginScreen();
  }
}

// ================================================
// LOGIN SCREEN - EXATO COMO REACT
// ================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Auto-fill para teste
    _emailController.text = 'joaoazul74@gmail.com';
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (response.user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Scaffold(
      body: Row(
        children: [
          // Left Side - Login Form
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryOlive,
                              AppColors.primaryOlive.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOlive.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Title
                      const Text(
                        'SIGA180',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Personal Trainer Management System',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'seu@email.com',
                          prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textGray),
                          filled: true,
                          fillColor: AppColors.background,
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textGray),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.textGray,
                            ),
                            onPressed: () {
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.background,
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
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Remember & Forgot Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: false,
                                  onChanged: (value) {},
                                  activeColor: AppColors.primaryOlive,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Lembrar-me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Esqueceu a password?',
                              style: TextStyle(
                                color: AppColors.primaryOlive,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Or Divider
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: AppColors.cardBorder)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OU', style: TextStyle(color: AppColors.lightGray)),
                          ),
                          Expanded(child: Container(height: 1, color: AppColors.cardBorder)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Social Login
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: AppColors.cardBorder),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Google'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: AppColors.cardBorder),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Apple'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não tem conta? ',
                            style: TextStyle(color: AppColors.textGray),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Registar agora',
                              style: TextStyle(
                                color: AppColors.primaryOlive,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Right Side - Pattern (Desktop only)
          if (isDesktop)
            Container(
              width: 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primaryDark.withOpacity(0.95),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Pattern Background
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.03,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) => Transform.rotate(
                          angle: 0.785398, // 45 degrees
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content Overlay
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Transforme Vidas',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Text(
                            'Gerencie seus atletas, crie planos personalizados e acompanhe o progresso em tempo real.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ================================================
// MAIN LAYOUT WITH SIDEBAR
// ================================================
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
        return const ScheduleScreen();
      case 5:
        return const ProgressScreen();
      case 6:
        return const FinancialScreen();
      case 7:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;
    
    if (isMobile) {
      // Mobile Layout with BottomNav
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _getPage(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryOlive,
          unselectedItemColor: AppColors.lightGray,
          items: _navigationItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          )).toList(),
        ),
      );
    }
    
    // Desktop/Tablet Layout with Sidebar
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // SIDEBAR
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isSidebarCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                right: BorderSide(color: AppColors.cardBorder.withOpacity(0.5)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo Header
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isSidebarCollapsed ? 16 : 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.cardBorder.withOpacity(0.5)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryOlive,
                              AppColors.primaryOlive.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOlive.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      if (!_isSidebarCollapsed) ...[
                        const SizedBox(width: 12),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIGA180',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Personal Trainer',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _selectedIndex == index;
                      
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: _isSidebarCollapsed ? 8 : 12,
                          vertical: 2,
                        ),
                        child: Material(
                          color: isSelected
                              ? AppColors.primaryOlive.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: _isSidebarCollapsed ? 20 : 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 22,
                                    color: isSelected
                                        ? AppColors.primaryOlive
                                        : AppColors.textGray,
                                  ),
                                  if (!_isSidebarCollapsed) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.primaryDark
                                              : AppColors.textGray,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 4,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryOlive,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // User Section
                Container(
                  padding: EdgeInsets.all(_isSidebarCollapsed ? 16 : 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.cardBorder.withOpacity(0.5)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.textGray],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user?.email?[0].toUpperCase() ?? 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!_isSidebarCollapsed) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.email?.split('@')[0] ?? 'User',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'Trainer Pro',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textGray),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline, size: 18),
                                  SizedBox(width: 12),
                                  Text('Perfil'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'settings',
                              child: Row(
                                children: [
                                  Icon(Icons.settings_outlined, size: 18),
                                  SizedBox(width: 12),
                                  Text('Configurações'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 18, color: AppColors.error),
                                  SizedBox(width: 12),
                                  Text('Sair', style: TextStyle(color: AppColors.error)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) async {
                            if (value == 'logout') {
                              await Supabase.instance.client.auth.signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ] else
                        IconButton(
                          icon: const Icon(Icons.logout, size: 20),
                          color: AppColors.textGray,
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
                
                // Collapse Toggle
                if (isDesktop)
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.cardBorder.withOpacity(0.5)),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isSidebarCollapsed
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSidebarCollapsed = !_isSidebarCollapsed;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          // Main Content Area
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
}

// ================================================
// DASHBOARD SCREEN
// ================================================
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athletesAsync = ref.watch(athletesStreamProvider);
    final user = Supabase.instance.client.auth.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, user),
              const SizedBox(height: 32),
              
              // Stats Grid
              _buildStatsGrid(athletesAsync),
              const SizedBox(height: 32),
              
              // Content Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTodaysSessions(),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildRecentAthletes(athletesAsync),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildTodaysSessions(),
                        const SizedBox(height: 24),
                        _buildRecentAthletes(athletesAsync),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(context),
            ],
          ),
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
                _StatsCard(
                  icon: Icons.people_rounded,
                  label: 'Total de Atletas',
                  value: '${stats['total']}',
                  color: 'dark',
                ),
                _StatsCard(
                  icon: Icons.show_chart_rounded,
                  label: 'Atletas Ativos',
                  value: '${stats['active']}',
                  color: 'olive',
                  trend: 12,
                ),
                _StatsCard(
                  icon: Icons.event_rounded,
                  label: 'Sessões Hoje',
                  value: '3',
                  color: 'accent',
                ),
                _StatsCard(
                  icon: Icons.emoji_events_rounded,
                  label: 'Novos Este Mês',
                  value: '${stats['new']}',
                  color: 'olive',
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

  Widget _buildTodaysSessions() {
    final sessions = [
      {'id': 1, 'athlete': {'name': 'João Silva'}, 'time': '14:00', 'duration': '1h', 'type': 'Treino de Força'},
      {'id': 2, 'athlete': {'name': 'Maria Santos'}, 'time': '15:00', 'duration': '1h', 'type': 'Cardio'},
      {'id': 3, 'athlete': {'name': 'Pedro Costa'}, 'time': '16:00', 'duration': '1h', 'type': 'Funcional'},
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
                onPressed: () {},
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
            Column(
              children: [
                Icon(Icons.calendar_today_rounded, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                const Text(
                  'Sem sessões agendadas para hoje',
                  style: TextStyle(color: AppColors.lightGray),
                ),
              ],
            )
          else
            ...sessions.map((session) => _TodaySessionCard(session: session)),
        ],
      ),
    );
  }

  Widget _buildRecentAthletes(AsyncValue<List<Map<String, dynamic>>> athletesAsync) {
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              return Column(
                children: [
                  ...athletes.take(5).map((athlete) => _RecentAthleteCard(athlete: athlete)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Adicionar Novo Atleta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
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

  Widget _buildQuickActions(BuildContext context) {
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

// ================================================
// STATS CARD WIDGET
// ================================================
class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String color;
  final int? trend;

  const _StatsCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  Color _getBackgroundColor() {
    switch (color) {
      case 'dark':
        return AppColors.primaryDark;
      case 'olive':
        return AppColors.accent;
      case 'accent':
        return AppColors.primaryOlive;
      default:
        return AppColors.accent;
    }
  }

  Color _getIconColor() {
    switch (color) {
      case 'dark':
        return Colors.white;
      case 'accent':
        return Colors.white;
      case 'olive':
        return AppColors.primaryDark;
      default:
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
                  color: _getBackgroundColor().withOpacity(color == 'olive' ? 1 : 0.1),
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
                    color: trend! > 0 ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
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

// ================================================
// SESSION & ATHLETE CARDS
// ================================================
class _TodaySessionCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const _TodaySessionCard({required this.session});

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

class _RecentAthleteCard extends StatelessWidget {
  final Map<String, dynamic> athlete;

  const _RecentAthleteCard({required this.athlete});

  @override
  Widget build(BuildContext context) {
    final name = athlete['name'] ?? 'Sem nome';
    
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
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              athlete['status'] ?? 'active',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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

// ================================================
// PLACEHOLDER SCREENS
// ================================================
class AthletesScreen extends StatelessWidget {
  const AthletesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Atletas',
      subtitle: 'Gerir atletas e perfis',
      icon: Icons.people_rounded,
    );
  }
}

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Treinos',
      subtitle: 'Criar e gerir planos de treino',
      icon: Icons.fitness_center_rounded,
    );
  }
}

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Nutrição',
      subtitle: 'Planos alimentares e acompanhamento',
      icon: Icons.restaurant_menu_rounded,
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Agenda',
      subtitle: 'Gerir sessões e compromissos',
      icon: Icons.calendar_today_rounded,
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Progresso',
      subtitle: 'Acompanhar evolução dos atletas',
      icon: Icons.bar_chart_rounded,
    );
  }
}

class FinancialScreen extends StatelessWidget {
  const FinancialScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Financeiro',
      subtitle: 'Gestão de pagamentos e relatórios',
      icon: Icons.attach_money_rounded,
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Configurações',
      subtitle: 'Personalizar a aplicação',
      icon: Icons.settings_rounded,
    );
  }
}

// ================================================
// HELPERS
// ================================================
class ScreenPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  
  const ScreenPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOlive.withOpacity(0.2),
                    AppColors.accent.withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppColors.primaryOlive,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.construction_rounded,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Em desenvolvimento',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;
  
  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

// ================================================
// PROVIDERS (RIVERPOD)
// ================================================
final athletesStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  
  if (userId == null) return Stream.value([]);
  
  return Supabase.instance.client
      .from('athletes')
      .stream(primaryKey: ['id'])
      .eq('trainer_id', userId)
      .order('created_at', ascending: false);
});