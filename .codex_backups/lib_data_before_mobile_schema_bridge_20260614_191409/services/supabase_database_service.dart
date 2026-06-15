import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';

class SupabaseTables {
  static const profiles = 'profiles';
  static const writerProfiles = 'writer_profiles';
  static const categories = 'categories';
  static const books = 'books';
  static const favorites = 'favorites';
  static const readingHistory = 'reading_history';
  static const reviews = 'reviews';
  static const pdfFiles = 'pdf_files';
  static const bookReactions = 'book_reactions';
  static const follows = 'follows';
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
