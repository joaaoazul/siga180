import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

// Athletes Stream Provider
final athletesStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) return Stream.value([]);
  
  return Supabase.instance.client
      .from('athletes')
      .stream(primaryKey: ['id'])
      .eq('trainer_id', userId)
      .order('created_at', ascending: false);
});

// Workouts Stream Provider
final workoutsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) return Stream.value([]);
  
  return Supabase.instance.client
      .from('workout_templates')
      .stream(primaryKey: ['id'])
      .eq('trainer_id', userId)
      .order('created_at', ascending: false);
});

// Session Stream Provider
final sessionsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) return Stream.value([]);
  
  final today = DateTime.now();
  final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  
  return Supabase.instance.client
      .from('workout_sessions')
      .stream(primaryKey: ['id'])
      .eq('trainer_id', userId)
      .eq('date', todayStr)
      .order('start_time', ascending: true);
});

extension on SupabaseStreamBuilder {
  eq(String s, String todayStr) {}
}

// Dashboard Stats Provider
final dashboardStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) {
    return {
      'totalAthletes': 0,
      'activeAthletes': 0,
      'todaySessions': 0,
      'monthlyRevenue': 0,
      'newAthletesThisMonth': 0,
    };
  }
  
  try {
    final client = Supabase.instance.client;
    
    // Fetch athletes
    final athletesResponse = await client
        .from('athletes')
        .select('id, status, created_at')
        .eq('trainer_id', userId);
    
    final athletes = List<Map<String, dynamic>>.from(athletesResponse);
    final totalAthletes = athletes.length;
    final activeAthletes = athletes.where((a) => a['status'] == 'active').length;
    
    // Calculate new athletes this month
    final now = DateTime.now();
    final newAthletesThisMonth = athletes.where((a) {
      final created = DateTime.tryParse(a['created_at'] ?? '');
      if (created == null) return false;
      return created.month == now.month && created.year == now.year;
    }).length;
    
    // Fetch today's sessions
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final sessionsResponse = await client
        .from('workout_sessions')
        .select('id')
        .eq('trainer_id', userId)
        .eq('date', todayStr);
    
    final todaySessions = (sessionsResponse as List).length;
    
    // Calculate monthly revenue (mock for now)
    final monthlyRevenue = activeAthletes * 80.0;
    
    return {
      'totalAthletes': totalAthletes,
      'activeAthletes': activeAthletes,
      'todaySessions': todaySessions,
      'monthlyRevenue': monthlyRevenue,
      'newAthletesThisMonth': newAthletesThisMonth,
    };
  } catch (e) {
    print('Error fetching dashboard stats: $e');
    return {
      'totalAthletes': 0,
      'activeAthletes': 0,
      'todaySessions': 0,
      'monthlyRevenue': 0,
      'newAthletesThisMonth': 0,
    };
  }
});