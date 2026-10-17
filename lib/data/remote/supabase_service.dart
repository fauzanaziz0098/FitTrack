import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  User? get currentUser => client?.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  /// Initialize Supabase with stored or default URL and AnonKey
  Future<bool> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('supabase_url') ?? SupabaseConstants.defaultUrl;
      final anonKey = prefs.getString('supabase_anon_key') ?? SupabaseConstants.defaultAnonKey;

      if (url.isEmpty || anonKey.isEmpty || url.contains('xyzcompany')) {
        debugPrint('[Supabase] Running in local/offline-first demo mode (Placeholder Supabase credentials)');
        _isInitialized = false;
        return false;
      }

      await Supabase.initialize(
        url: url,
        // ignore: deprecated_member_use
        anonKey: anonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      _isInitialized = true;
      debugPrint('[Supabase] Initialized successfully with $url');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Initialization error: $e. Operating in offline/local mode.');
      _isInitialized = false;
      return false;
    }
  }

  /// Reconfigure Supabase with new credentials
  Future<bool> configureCredentials({required String url, required String anonKey}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('supabase_url', url.trim());
    await prefs.setString('supabase_anon_key', anonKey.trim());
    return await initialize();
  }

  /// Sign Up with email and password
  Future<AuthResponse?> signUp({required String email, required String password}) async {
    final cl = client;
    if (cl == null) throw Exception('Supabase belum terhubung. Periksa konfigurasi URL & Key.');
    return await cl.auth.signUp(email: email, password: password);
  }

  /// Sign In with email and password
  Future<AuthResponse?> signIn({required String email, required String password}) async {
    final cl = client;
    if (cl == null) throw Exception('Supabase belum terhubung. Periksa konfigurasi URL & Key.');
    return await cl.auth.signInWithPassword(email: email, password: password);
  }

  /// Sign In with Google OAuth SSO
  Future<bool> signInWithGoogle() async {
    final cl = client;
    if (cl == null) throw Exception('Supabase belum terhubung. Periksa konfigurasi URL & Key.');
    return await cl.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.fittrack://login-callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  /// Sign Out
  Future<void> signOut() async {
    final cl = client;
    if (cl != null) {
      await cl.auth.signOut();
    }
  }

  // --- Remote Database Methods for Sync Engine ---

  Future<List<Map<String, dynamic>>> fetchGlobalFoods() async {
    final cl = client;
    if (cl == null) return [];
    try {
      final response = await cl.from(SupabaseConstants.foodsTable).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[Supabase] fetchGlobalFoods error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final cl = client;
    if (cl == null) return null;
    try {
      final response = await cl.from(SupabaseConstants.profilesTable).select().eq('id', userId).maybeSingle();
      return response;
    } catch (e) {
      debugPrint('[Supabase] fetchUserProfile error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserMealLogs(String userId) async {
    final cl = client;
    if (cl == null) return [];
    try {
      final response = await cl.from(SupabaseConstants.mealLogsTable).select().eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[Supabase] fetchUserMealLogs error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserWeightLogs(String userId) async {
    final cl = client;
    if (cl == null) return [];
    try {
      final response = await cl.from(SupabaseConstants.weightLogsTable).select().eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[Supabase] fetchUserWeightLogs error: $e');
      return [];
    }
  }

  Future<void> upsertProfile(Map<String, dynamic> data) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.profilesTable).upsert(data);
  }

  Future<void> upsertFood(Map<String, dynamic> data) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.foodsTable).upsert(data);
  }

  Future<void> upsertMealLog(Map<String, dynamic> data) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.mealLogsTable).upsert(data);
  }

  Future<void> deleteMealLog(String id) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.mealLogsTable).delete().eq('id', id);
  }

  Future<void> upsertWeightLog(Map<String, dynamic> data) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.weightLogsTable).upsert(data);
  }

  Future<void> deleteWeightLog(String id) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.weightLogsTable).delete().eq('id', id);
  }
}
