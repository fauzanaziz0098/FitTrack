import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    try {
      final cl = Supabase.instance.client;
      _isInitialized = true;
      return cl;
    } catch (_) {
      return null;
    }
  }

  User? get currentUser => client?.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  /// Initialize Supabase with stored or default URL and AnonKey
  Future<bool> initialize() async {
    String url = SupabaseConstants.defaultUrl;
    String anonKey = SupabaseConstants.defaultAnonKey;

    try {
      final prefs = await SharedPreferences.getInstance();
      url = prefs.getString('supabase_url') ?? url;
      anonKey = prefs.getString('supabase_anon_key') ?? anonKey;
    } catch (e) {
      debugPrint('[Supabase] SharedPreferences lookup error: $e. Using default constants.');
    }

    if (url.isEmpty || anonKey.isEmpty || url.contains('xyzcompany')) {
      debugPrint('[Supabase] Running in local/offline-first demo mode (Placeholder Supabase credentials)');
      _isInitialized = false;
      return false;
    }

    try {
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

  /// Native Google Sign-In (dialog akun langsung di dalam aplikasi tanpa membuka browser)
  Future<AuthResponse?> signInWithGoogleNative({
    String? webClientId,
    String? iosClientId,
  }) async {
    final cl = client;
    if (cl == null) throw Exception('Supabase belum terhubung. Periksa koneksi internet.');

    final effectiveWebClientId = (webClientId != null && webClientId.isNotEmpty)
        ? webClientId
        : SupabaseConstants.googleWebClientId;

    final effectiveIosClientId = (iosClientId != null && iosClientId.isNotEmpty)
        ? iosClientId
        : SupabaseConstants.googleIosClientId;

    final isIos = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final googleSignIn = GoogleSignIn(
      serverClientId: effectiveWebClientId.isNotEmpty ? effectiveWebClientId : null,
      clientId: isIos && effectiveIosClientId.isNotEmpty ? effectiveIosClientId : null,
      scopes: const ['email', 'profile'],
    );

    // Pastikan sesi lokal sebelumnya dibersihkan agar popup daftar akun selalu muncul
    try {
      await googleSignIn.signOut();
    } catch (_) {}

    // Langsung munculkan popup daftar akun Google di ponsel
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User membatalkan dialog akun Google
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      if (effectiveWebClientId.isEmpty) {
        throw Exception(
            'Web Client ID Google belum diisi di SupabaseConstants. Diperlukan Web Client ID agar Google menerbitkan ID Token.');
      }
      throw Exception(
          'Google tidak mengembalikan ID Token. Pastikan OAuth Client ID bertipe Web Application di Google Cloud Console sudah benar.');
    }

    return await cl.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Sign In with Google OAuth SSO (Browser fallback)
  Future<bool> signInWithGoogle() async {
    final cl = client;
    if (cl == null) throw Exception('Supabase belum terhubung. Periksa konfigurasi URL & Key.');
    return await cl.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.ironbite://login-callback',
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

  // --- Remote Database Methods ---

  Future<List<Map<String, dynamic>>> fetchFoods({String? userId, String? query}) async {
    final cl = client;
    if (cl == null) return [];
    try {
      var q = cl.from(SupabaseConstants.foodsTable).select();
      if (userId != null && userId.isNotEmpty) {
        q = q.or('user_id.is.null,user_id.eq.$userId');
      } else {
        q = q.filter('user_id', 'is', 'null');
      }
      if (query != null && query.trim().isNotEmpty) {
        q = q.ilike('name', '%${query.trim()}%');
      }
      final response = await q.order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[Supabase] fetchFoods error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchGlobalFoods() async {
    return await fetchFoods();
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

  Future<List<Map<String, dynamic>>> fetchUserMealLogs(String userId, {DateTime? date}) async {
    final cl = client;
    if (cl == null) return [];
    try {
      var query = cl
          .from(SupabaseConstants.mealLogsTable)
          .select('*, foods(name)')
          .eq('user_id', userId);

      if (date != null) {
        final dateStr = date.toIso8601String().split('T').first;
        query = query.eq('logged_date', dateStr);
      }

      final response = await query.order('created_at', ascending: true);
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
      final response = await cl
          .from(SupabaseConstants.weightLogsTable)
          .select()
          .eq('user_id', userId)
          .order('logged_date', ascending: true);
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
    await cl.from(SupabaseConstants.weightLogsTable).upsert(
      data,
      onConflict: 'user_id,logged_date',
    );
  }

  Future<void> deleteWeightLog(String id) async {
    final cl = client;
    if (cl == null) return;
    await cl.from(SupabaseConstants.weightLogsTable).delete().eq('id', id);
  }
}
