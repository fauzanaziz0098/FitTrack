import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/app_splash_screen.dart';
import 'data/remote/supabase_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/calculator/screens/tdee_calculator_screen.dart';
import 'features/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale formatting agar tidak terjadi LocaleDataException
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Supabase menggunakan kredensial env
  await SupabaseService.instance.initialize();

  runApp(
    const ProviderScope(
      child: IronBiteApp(),
    ),
  );
}

class IronBiteApp extends ConsumerStatefulWidget {
  const IronBiteApp({super.key});

  @override
  ConsumerState<IronBiteApp> createState() => _IronBiteAppState();
}

class _IronBiteAppState extends ConsumerState<IronBiteApp> {
  bool _isDbReady = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final repo = ref.read(ironBiteRepositoryProvider);
    await repo.initDatabase();
    if (mounted) {
      setState(() => _isDbReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeNotifierProvider);

    if (!_isDbReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(themeState.accent.color),
        darkTheme: AppTheme.darkTheme(themeState.accent.color),
        themeMode: themeState.themeMode,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFE5FE40)),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'IronBite - Lifter Nutrition & Progress',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeState.accent.color),
      darkTheme: AppTheme.darkTheme(themeState.accent.color),
      themeMode: themeState.themeMode,
      home: const _AppRootDecider(),
    );
  }
}

class _AppRootDecider extends ConsumerStatefulWidget {
  const _AppRootDecider();

  @override
  ConsumerState<_AppRootDecider> createState() => _AppRootDeciderState();
}

class _AppRootDeciderState extends ConsumerState<_AppRootDecider> {
  String? _lastSyncedUserId;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser != null && currentUser.id != _lastSyncedUserId) {
      _lastSyncedUserId = currentUser.id;
      Future.microtask(() {
        ref.read(ironBiteRepositoryProvider).syncUserDataFromRemote();
      });
    } else if (currentUser == null) {
      _lastSyncedUserId = null;
    }

    // Jika belum login ke Supabase, tahan di layar Auth
    if (currentUser == null) {
      return const AuthScreen();
    }

    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => const AppSplashScreen(),
      error: (err, _) => const Scaffold(
        body: Center(
          child: Text('Gagal memuat profil pengguna.'),
        ),
      ),
      data: (profile) {
        // Jika profil belum pernah dihitung, arahkan ke onboarding kalkulator TDEE
        if (profile == null) {
          return const TdeeCalculatorScreen();
        }
        return const MainNavigationScreen();
      },
    );
  }
}
