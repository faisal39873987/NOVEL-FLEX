import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';

class SupabaseTables {
  static const profiles = 'profiles';
  static const writerProfiles = 'writer_profiles';
  static const categories = 'categories';
  static const books = 'books';
  static const chapters = 'chapters';
  static const favorites = 'favorites';
  static const readingProgress = 'reading_progress';
  static const ratings = 'ratings';
  static const reviews = ratings;
  static const bookReactions = 'book_reactions';
  static const follows = 'follows';
  static const notifications = 'notifications';
  static const bookViewEvents = 'book_view_events';
  static const chapterReadEvents = 'chapter_read_events';

  // Legacy compatibility aliases only. New code should use the canonical
  // constants above and should not introduce these table names as DB targets.
  static const legacyAuthors = writerProfiles;
  static const legacyPdfFiles = chapters;
  static const legacyReviews = ratings;
  static const legacyReadingHistory = readingProgress;
  static const pdfFiles = legacyPdfFiles;
}

class SupabaseDatabaseService {
  SupabaseDatabaseService({SupabaseClient? client})
      : client = client ?? SupabaseConfig.client;

  final SupabaseClient client;

  SupabaseQueryBuilder table(String tableName) => client.from(tableName);

  Future<T> run<T>(
    Future<T> Function() operation, {
    String message = 'Database request failed.',
  }) async {
    try {
      return await operation();
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppDatabaseException(message, cause: error);
    }
  }

  List<Map<String, dynamic>> mapList(dynamic response) {
    final rows = response as List<dynamic>;
    return rows
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  Map<String, dynamic> map(dynamic response) {
    return Map<String, dynamic>.from(response as Map);
  }

  Map<String, dynamic>? nullableMap(dynamic response) {
    if (response == null) {
      return null;
    }
    return map(response);
  }
}
