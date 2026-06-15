import 'dart:io';

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

  group('authorization guards', () {
    test('web author and admin routes require explicit roles', () {
      final webApp = File('web/frontend-ui/app.js').readAsStringSync();

      expect(
        webApp,
        contains('return ["writer", "admin"].includes(role);'),
      );
      expect(webApp, contains('function requireOwnedAuthorBook(bookId)'));
      expect(
        webApp,
        contains('لوحة الإدارة مخصصة لحسابات role admin فقط.'),
      );
    });

    test('mobile Supabase repository guards write ownership', () {
      final repository =
          File('lib/data/repositories/book_repository.dart').readAsStringSync();

      expect(repository, contains('await _requireWriterOrAdminForAuthor'));
      expect(repository, contains('await _requireBookOwnership(bookId)'));
      expect(repository, contains('Future<void> deleteChapter'));
      expect(repository, contains("role != 'writer'"));
      expect(repository, contains("role == 'admin'"));
    });
  });
}
