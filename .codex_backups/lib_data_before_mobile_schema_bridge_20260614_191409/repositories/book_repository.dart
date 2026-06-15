import '../services/supabase_database_service.dart';
import '../utils/supabase_query.dart';

class CreateBookInput {
  const CreateBookInput({
    required this.authorId,
    required this.title,
    this.categoryId,
    this.subcategoryId,
    this.description,
    this.language,
    this.coverImagePath,
    this.coverImageUrl,
    this.pdfPath,
    this.audioPath,
    this.textContent,
    this.paymentStatus = 1,
    this.status = 'published',
  });

  final String authorId;
  final String title;
  final int? categoryId;
  final int? subcategoryId;
  final String? description;
  final String? language;
  final String? coverImagePath;
  final String? coverImageUrl;
  final String? pdfPath;
  final String? audioPath;
  final String? textContent;
  final int paymentStatus;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'author_id': authorId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'title': title,
      'description': description,
      'language': language,
      'cover_image_path': coverImagePath,
      'cover_image_url': coverImageUrl,
      'pdf_path': pdfPath,
      'audio_path': audioPath,
      'text_content': textContent,
      'payment_status': paymentStatus,
      'status': status,
      'published_at': status == 'published'
          ? DateTime.now().toUtc().toIso8601String()
          : null,
    }..removeWhere((_, value) => value == null);
  }
}

class SupabaseBookRepository {
  SupabaseBookRepository({SupabaseDatabaseService? database})
      : _database = database ?? SupabaseDatabaseService();

  final SupabaseDatabaseService _database;

  static const _bookSelect = '*, authors(*, users(*, profiles(*))), '
      'category:categories!books_category_id_fkey(*), '
      'subcategory:categories!books_subcategory_id_fkey(*)';

  Future<List<Map<String, dynamic>>> getPublishedBooks({int limit = 30}) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('status', 'published')
            .eq('is_active', true)
            .filter('deleted_at', 'is', null)
            .order('published_at', ascending: false)
            .limit(limit);

        return _database.mapList(response);
      },
      message: 'Failed to load books.',
    );
  }

  Future<List<Map<String, dynamic>>> getRecentBooks({int limit = 20}) {
    return getPublishedBooks(limit: limit);
  }

  Future<Map<String, dynamic>?> getBookById(int bookId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('id', bookId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load book.',
    );
  }

  Future<List<Map<String, dynamic>>> getBooksByAuthor(String authorId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('author_id', authorId)
            .filter('deleted_at', 'is', null)
            .order('created_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to load author books.',
    );
  }

  Future<List<Map<String, dynamic>>> getBooksByCategory(int categoryId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('category_id', categoryId)
            .eq('status', 'published')
            .eq('is_active', true)
            .filter('deleted_at', 'is', null)
            .order('published_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to load category books.',
    );
  }

  Future<List<Map<String, dynamic>>> searchBooks(String query) {
    final pattern = supabaseContainsPattern(query);
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('status', 'published')
            .eq('is_active', true)
            .filter('deleted_at', 'is', null)
            .or('title.ilike.$pattern,description.ilike.$pattern')
            .order('published_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to search books.',
    );
  }

  Future<List<Map<String, dynamic>>> getBookPdfFiles(int bookId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.pdfFiles)
            .select()
            .eq('book_id', bookId)
            .eq('is_active', true)
            .filter('deleted_at', 'is', null)
            .order('chapter_number')
            .order('created_at');

        return _database.mapList(response);
      },
      message: 'Failed to load PDF files.',
    );
  }

  Future<Map<String, dynamic>?> getPdfFileById(int pdfFileId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.pdfFiles)
            .select('*, books(*)')
            .eq('id', pdfFileId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load PDF file.',
    );
  }

  Future<Map<String, dynamic>> createBook(CreateBookInput input) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .insert(input.toJson())
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to create book.',
    );
  }

  Future<Map<String, dynamic>> updateBook(
    int bookId,
    Map<String, dynamic> fields,
  ) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .update(<String, dynamic>{
              ...fields,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }..removeWhere((_, value) => value == null))
            .eq('id', bookId)
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to update book.',
    );
  }

  Future<void> softDeleteBook(int bookId) {
    return _database.run(
      () async {
        await _database.table(SupabaseTables.books).update(<String, dynamic>{
          'status': 'deleted',
          'is_active': false,
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', bookId);
      },
      message: 'Failed to delete book.',
    );
  }
}
