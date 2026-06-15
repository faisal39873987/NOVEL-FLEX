import 'package:flutter_test/flutter_test.dart';
import 'package:novelflex/Utils/ApiUtils.dart';
import 'package:novelflex/core/config/supabase_config.dart';
import 'package:novelflex/data/services/supabase_database_service.dart';

void main() {
  group('launch configuration', () {
    test('legacy REST API is disabled by default', () {
      expect(ApiUtils.ENABLE_LEGACY_API, isFalse);
      expect(ApiUtils.BASE, 'https://legacy-api-disabled.novelflex.invalid');
      expect(
        ApiUtils.DELETE_ACCOUNT_PROFILE_API,
        isNot(contains('apptocom.com/novelflex2/api/v1')),
      );
    });

    test('Supabase is opt-in through dart defines', () {
      expect(SupabaseConfig.hasEnvironment, isFalse);
    });
  });

  group('Supabase canonical table contract', () {
    test('uses canonical production table names', () {
      expect(SupabaseTables.profiles, 'profiles');
      expect(SupabaseTables.writerProfiles, 'writer_profiles');
      expect(SupabaseTables.books, 'books');
      expect(SupabaseTables.chapters, 'chapters');
      expect(SupabaseTables.ratings, 'ratings');
      expect(SupabaseTables.readingProgress, 'reading_progress');
    });

    test('legacy aliases resolve to canonical tables only', () {
      expect(SupabaseTables.legacyAuthors, SupabaseTables.writerProfiles);
      expect(SupabaseTables.legacyPdfFiles, SupabaseTables.chapters);
      expect(SupabaseTables.legacyReviews, SupabaseTables.ratings);
      expect(
        SupabaseTables.legacyReadingHistory,
        SupabaseTables.readingProgress,
      );
    });
  });
}
