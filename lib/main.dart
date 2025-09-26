import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/presentation/main_layout.dart';
import 'features/auth/presentation/screens/login_screen.dart';

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
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://qxjaofxqujnufirdcwgc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4amFvZnhxdWpudWZpcmRjd2djIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3MDQ4MzQsImV4cCI6MjA3NDI4MDgzNH0.hrxLaXJ2dVgL3u2DpcDIIWuk0hp7lr7aNVJfExgwuYI',
  );
  
  runApp(
    const ProviderScope(
      child: Siga180App(),
    ),
  );
}

class Siga180App extends StatelessWidget {
  const Siga180App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGA180',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null ? const MainLayout() : const LoginScreen();
  }
}