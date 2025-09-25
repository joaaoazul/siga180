import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;
  
  // Athletes
  static Future<List<Map<String, dynamic>>> getAthletes(String trainerId) async {
    final response = await client
        .from('athletes')
        .select()
        .eq('trainer_id', trainerId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
  
  // Add more methods as needed
}
