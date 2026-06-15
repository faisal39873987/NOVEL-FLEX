import '../services/supabase_database_service.dart';
import '../utils/supabase_query.dart';

class SupabaseAuthorRepository {
  SupabaseAuthorRepository({SupabaseDatabaseService? database})
      : _database = database ?? SupabaseDatabaseService();

  final SupabaseDatabaseService _database;

  static const _authorSelect = 'id,user_id,pen_name,bio_ar,bio_en,'
      'website_url,social_links,is_approved,created_at,updated_at,'
      'profile:profiles!writer_profiles_user_id_fkey'
      '(id,display_name,username,avatar_url,bio)';

  Future<List<Map<String, dynamic>>> getAuthors({int limit = 50}) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.writerProfiles)
            .select(_authorSelect)
            .order('created_at', ascending: false)
            .limit(limit);

        return _database.mapList(response);
      },
      message: 'Failed to load authors.',
    );
  }

  Future<List<Map<String, dynamic>>> searchAuthors(
    String query, {
    int limit = 50,
  }) {
    final pattern = supabaseContainsPattern(query);
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.writerProfiles)
            .select(_authorSelect)
            .or(
              'pen_name.ilike.$pattern,'
              'bio_ar.ilike.$pattern,'
              'bio_en.ilike.$pattern',
            )
            .order('created_at', ascending: false)
            .limit(limit);

        return _database.mapList(response);
      },
      message: 'Failed to search authors.',
    );
  }

  Future<Map<String, dynamic>?> getAuthorById(String authorId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.writerProfiles)
            .select(_authorSelect)
            .eq('id', authorId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load author.',
    );
  }

  Future<Map<String, dynamic>?> getAuthorByUserId(String userId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.writerProfiles)
            .select(_authorSelect)
            .eq('user_id', userId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load author profile.',
    );
  }

  Future<Map<String, dynamic>> upsertAuthor({
    required String userId,
    String? penName,
    String? description,
    bool isAcceptingSubscribers = true,
  }) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.writerProfiles)
            .upsert(<String, dynamic>{
              'user_id': userId,
              'pen_name': penName,
              'bio_ar': description,
              'bio_en': description,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }..removeWhere((_, value) => value == null))
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to save author.',
    );
  }
}
