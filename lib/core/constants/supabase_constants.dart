class SupabaseConstants {
  // Supabase Project IronBite (ap-northeast-1)
  static const String defaultUrl = 'https://apsbfartmrhrxdbnaeme.supabase.co';
  static const String defaultAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwc2JmYXJ0bXJocnhkYm5hZW1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIyMzQ3ODEsImV4cCI6MjEwNzgxMDc4MX0.M0-QeiVe65afA64nu1y7kMrbSZxvpJiAb829OV2x1qQ';

  // Google OAuth Web Client ID (digunakan sebagai serverClientId untuk native Android sign-in)
  static const String googleWebClientId = '621368473254-pmot5csh7dipl3a4nhbfqsug2p32g635.apps.googleusercontent.com';
  // Google OAuth iOS Client ID
  static const String googleIosClientId = '621368473254-0nj7np69maibfdr2fedrtohvejiven82.apps.googleusercontent.com';

  // Table names matching PRD PostgreSQL schema
  static const String profilesTable = 'profiles';
  static const String foodsTable = 'foods';
  static const String mealLogsTable = 'meal_logs';
  static const String weightLogsTable = 'weight_logs';
}
