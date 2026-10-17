import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/google_logo.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Email dan password tidak boleh kosong.'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Password minimal 6 karakter.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabase = ref.read(supabaseServiceProvider);
      if (_isSignUp) {
        final res = await supabase.signUp(email: email, password: password);
        if (mounted) {
          if (res?.session != null) {
            await ref.read(ironBiteRepositoryProvider).triggerFullSync();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primary,
                  content: const Text('Pendaftaran dan login berhasil.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              );
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.primary,
                content: const Text('Pendaftaran berhasil. Silakan masuk.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            );
            setState(() => _isSignUp = false);
          }
        }
      } else {
        await supabase.signIn(email: email, password: password);
        await ref.read(ironBiteRepositoryProvider).triggerFullSync();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              content: const Text('Login berhasil.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          );
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        String msg = _isSignUp ? 'Pendaftaran gagal. Periksa data Anda.' : 'Email atau password salah.';
        final errLower = e.toString().toLowerCase();
        if (errLower.contains('network') || errLower.contains('socket') || errLower.contains('host')) {
          msg = 'Gagal terhubung. Periksa koneksi internet.';
        } else if (errLower.contains('already') || errLower.contains('registered')) {
          msg = 'Email sudah terdaftar. Silakan masuk.';
        } else if (errLower.contains('invalid login') || errLower.contains('invalid credentials')) {
          msg = 'Email atau password salah.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(msg),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final supabase = ref.read(supabaseServiceProvider);
      // Langsung munculkan popup daftar akun Google di ponsel
      final res = await supabase.signInWithGoogleNative();
      if (res != null && res.session != null) {
        await ref.read(ironBiteRepositoryProvider).triggerFullSync();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              content: const Text('Login berhasil.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          );
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        String msg = 'Login dibatalkan.';
        final errLower = e.toString().toLowerCase();
        if (errLower.contains('network') || errLower.contains('socket')) {
          msg = 'Gagal terhubung. Periksa koneksi internet.';
        } else if (errLower.contains('client id')) {
          msg = 'Web Client ID Google belum terpasang di SupabaseConstants.';
        } else if (errLower.contains('cancel') || errLower.contains('batal')) {
          msg = 'Login Google dibatalkan.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(msg),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: Navigator.canPop(context),
        title: Text(_isSignUp ? 'Buat Akun IronBite' : 'Masuk Akun IronBite'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.fitness_center,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isSignUp ? 'Daftar Akun Lifter' : 'Selamat Datang di IronBite',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _isSignUp
                  ? 'Buat akun untuk memulai pelacakan nutrisi presisi dan progres fisik Anda.'
                  : 'Masuk akun untuk mengakses dashboard dan mengontrol target kalori harian Anda.',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'lifter@ironbite.app',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Minimal 6 karakter',
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleAuth,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : Text(
                      _isSignUp ? 'Daftar Sekarang' : 'Masuk',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 16),

            // Switch Mode Button
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp
                    ? 'Sudah punya akun? Masuk di sini'
                    : 'Belum punya akun? Daftar gratis sekarang',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),

            // Divider ATAU
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.surfaceLight, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'ATAU',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.surfaceLight, thickness: 1)),
              ],
            ),
            const SizedBox(height: 16),

            // Google SSO Button
            OutlinedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.surfaceLight, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GoogleLogo(size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Lanjutkan dengan Google',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Offline info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.security_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data profil, riwayat makan, dan timbangan tersimpan privat di Supabase Cloud serta tersinkronisasi offline di Drift SQLite.',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
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
