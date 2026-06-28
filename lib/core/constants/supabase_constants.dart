/// Supabase project credentials for image storage (free tier — no Blaze plan needed).
///
/// 1. Create a project at https://supabase.com (free, no card required).
/// 2. Project Settings → API → copy Project URL and anon public key.
/// 3. Paste them below.
/// 4. Run the SQL in `supabase/storage_setup.sql` in the Supabase SQL Editor.
class SupabaseConstants {
  SupabaseConstants._();

  /// Example: https://xxxxxxxxxxxx.supabase.co
  static const String url = 'https://tfoubqdwjwwcusaiywpm.supabase.co';

  /// Project Settings → API → anon **public** key (starts with eyJ…, NOT sb_secret_)
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmb3VicWR3and3Y3VzYWl5d3BtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI2NTA1NjQsImV4cCI6MjA5ODIyNjU2NH0.1NWdyv5O-h91OgirVHyIGkH5ELdeDlhiW2ZmyY8ombc';

  static const String productImagesBucket = 'products';

  static bool get isConfigured =>
      url != 'YOUR_SUPABASE_URL' &&
      anonKey != 'YOUR_SUPABASE_ANON_KEY' &&
      url.isNotEmpty &&
      anonKey.isNotEmpty;
}
