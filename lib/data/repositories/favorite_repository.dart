import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../services/supabase_database_service.dart';

class SupabaseFavoriteRepository {
  SupabaseFavoriteRepository({SupabaseDatabaseService? database})
      : _database = database ?? SupabaseDatabaseService();

  final SupabaseDatabaseService _database;

  User? get _currentUser => _database.client.auth.currentUser;

  String get _currentUserId {
    final user = _currentUser;
    if (user == null) {
      throw const AppSessionException('No authenticated user.');
    }
    return user.id;
  }

  Future<List<Map<String, dynamic>>> getMyFavorites() {
    return getFavoritesForUser(_currentUserId);
  }

  Future<List<Map<String, dynamic>>> getFavoritesForUser(String userId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.favorites)
            .select('created_at, books(*)')
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to load favorites.',
    );
  }

  Future<bool> isFavorite(String bookId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.favorites)
            .select('book_id')
            .eq('user_id', _currentUserId)
            .eq('book_id', bookId)
            .maybeSingle();

        return response != null;
      },
      message: 'Failed to check favorite.',
    );
  }

  Future<void> addFavorite(String bookId) {
    return _database.run(
      () async {
        await _database.table(SupabaseTables.favorites).upsert(
          <String, dynamic>{
            'user_id': _currentUserId,
            'book_id': bookId,
          },
        );
      },
      message: 'Failed to add favorite.',
    );
  }

  Future<void> removeFavorite(String bookId) {
    return _database.run(
      () async {
        await _database
            .table(SupabaseTables.favorites)
            .delete()
            .eq('user_id', _currentUserId)
            .eq('book_id', bookId);
      },
      message: 'Failed to remove favorite.',
    );
  }
}
