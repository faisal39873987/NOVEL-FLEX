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
            .eq('is_active', true)
            .order('sort_order')
            .order('name_ar');

        return _database.mapList(response);
      },
      message: 'Failed to load categories.',
    );
  }

  Future<List<Map<String, dynamic>>> getSubcategories(String categoryId) async {
    return <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>?> getCategoryById(String categoryId) {
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
            .or(
              'name_ar.ilike.$pattern,'
              'name_en.ilike.$pattern,'
              'description_ar.ilike.$pattern,'
              'description_en.ilike.$pattern',
            )
            .order('sort_order')
            .order('name_ar');

        return _database.mapList(response);
      },
      message: 'Failed to search categories.',
    );
  }
}
