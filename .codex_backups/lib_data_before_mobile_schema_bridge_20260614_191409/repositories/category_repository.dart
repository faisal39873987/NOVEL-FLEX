import '../services/supabase_database_service.dart';
import '../utils/supabase_query.dart';

class SupabaseCategoryRepository {
  SupabaseCategoryRepository({SupabaseDatabaseService? database})
      : _database = database ?? SupabaseDatabaseService();

  final SupabaseDatabaseService _database;

  Future<List<Map<String, dynamic>>> getActiveCategories() {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.categories)
            .select()
            .filter('parent_id', 'is', null)
            .eq('is_active', true)
            .order('sort_order')
            .order('title');

        return _database.mapList(response);
      },
      message: 'Failed to load categories.',
    );
  }

  Future<List<Map<String, dynamic>>> getSubcategories(int categoryId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.categories)
            .select()
            .eq('parent_id', categoryId)
            .eq('is_active', true)
            .order('sort_order')
            .order('title');

        return _database.mapList(response);
      },
      message: 'Failed to load subcategories.',
    );
  }

  Future<Map<String, dynamic>?> getCategoryById(int categoryId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.categories)
            .select()
            .eq('id', categoryId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load category.',
    );
  }

  Future<List<Map<String, dynamic>>> searchCategories(String query) {
    final pattern = supabaseContainsPattern(query);
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.categories)
            .select()
            .eq('is_active', true)
            .or('title.ilike.$pattern,title_ar.ilike.$pattern')
            .order('title');

        return _database.mapList(response);
      },
      message: 'Failed to search categories.',
    );
  }
}
