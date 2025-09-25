import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
