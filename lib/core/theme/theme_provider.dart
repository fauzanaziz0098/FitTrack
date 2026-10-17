import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAccent {
  final String id;
  final String name;
  final Color color;

  const AppAccent({
    required this.id,
    required this.name,
    required this.color,
  });
}

class AppAccents {
  static const AppAccent volt = AppAccent(
    id: 'volt',
    name: 'Electric Volt',
    color: Color(0xFFE5FE40),
  );
  static const AppAccent crimson = AppAccent(
    id: 'crimson',
    name: 'Flame Crimson',
    color: Color(0xFFFF453A),
  );
  static const AppAccent cyan = AppAccent(
    id: 'cyan',
    name: 'Cyber Cyan',
    color: Color(0xFF00D2FF),
  );
  static const AppAccent emerald = AppAccent(
    id: 'emerald',
    name: 'Neon Emerald',
    color: Color(0xFF00E676),
  );
  static const AppAccent orange = AppAccent(
    id: 'orange',
    name: 'Athletic Orange',
    color: Color(0xFFFF7A00),
  );
  static const AppAccent violet = AppAccent(
    id: 'violet',
    name: 'Hyper Violet',
    color: Color(0xFFA855F7),
  );

  static const List<AppAccent> all = [
    volt,
    crimson,
    cyan,
    emerald,
    orange,
    violet,
  ];

  static AppAccent fromId(String? id) {
    if (id == null) return volt;
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => volt,
    );
  }
}

class ThemeState {
  final ThemeMode themeMode;
  final AppAccent accent;

  const ThemeState({
    required this.themeMode,
    required this.accent,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppAccent? accent,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accent: accent ?? this.accent,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyAccent = 'app_theme_accent';

  @override
  ThemeState build() {
    _loadFromPreferences();
    return const ThemeState(
      themeMode: ThemeMode.dark,
      accent: AppAccents.volt,
    );
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_keyThemeMode);
      final accentId = prefs.getString(_keyAccent);

      ThemeMode mode = ThemeMode.dark;
      if (modeStr == 'light') {
        mode = ThemeMode.light;
      } else if (modeStr == 'system') {
        mode = ThemeMode.system;
      }

      final accent = AppAccents.fromId(accentId);
      state = ThemeState(themeMode: mode, accent: accent);
    } catch (e) {
      debugPrint('[Theme] Error loading theme preferences: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);

    try {
      final prefs = await SharedPreferences.getInstance();
      String modeStr = 'dark';
      if (mode == ThemeMode.light) {
        modeStr = 'light';
      } else if (mode == ThemeMode.system) {
        modeStr = 'system';
      }
      await prefs.setString(_keyThemeMode, modeStr);
    } catch (_) {}
  }

  Future<void> setAccent(AppAccent accent) async {
    state = state.copyWith(accent: accent);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAccent, accent.id);
    } catch (_) {}
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});
