import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../models/athlete_model.dart';

class AthletesService {
  final SupabaseClient _client = Supabase.instance.client;
  
  Stream<List<Athlete>> getAthletes() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);
    
    return _client
        .from('athletes')
        .stream(primaryKey: ['id'])
        .eq('trainer_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Athlete.fromJson(json)).toList());
  }
  
  Future<Athlete> createAthlete(Map<String, dynamic> data) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    
    data['trainer_id'] = userId;
    data['created_at'] = DateTime.now().toIso8601String();
    data['status'] = data['status'] ?? 'active';
    
    final response = await _client
        .from('athletes')
        .insert(data)
        .select()
        .single();
    
    return Athlete.fromJson(response);
  }
  
  Future<Athlete> updateAthlete(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    
    final response = await _client
        .from('athletes')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    
    return Athlete.fromJson(response);
  }
  
  Future<void> deleteAthlete(String id) async {
    await _client
        .from('athletes')
        .delete()
        .eq('id', id);
  }
  
  Future<Athlete?> getAthleteById(String id) async {
    try {
      final response = await _client
          .from('athletes')
          .select()
          .eq('id', id)
          .single();
      
      return Athlete.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}// --- IGNORE ---