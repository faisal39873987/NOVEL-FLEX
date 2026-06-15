import '../../core/errors/app_exception.dart';
import '../services/supabase_database_service.dart';
import '../utils/supabase_query.dart';

class CreateBookInput {
  const CreateBookInput({
    required this.authorId,
    required this.title,
    this.categoryId,
    this.description,
    this.language,
    this.coverImageUrl,
    this.status = 'draft',
  });

  final String authorId;
  final String title;
  final String? categoryId;
  final String? description;
  final String? language;
  final String? coverImageUrl;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'author_id': authorId,
      'category_id': categoryId,
      'title_ar': title,
      'description_ar': description,
      'language': language ?? 'ar',
      'cover_url': coverImageUrl,
      'status': status,
      'published_at': status == 'published'
          ? DateTime.now().toUtc().toIso8601String()
          : null,
    }..removeWhere((_, value) => value == null);
  }
}

class CreateChapterInput {
  const CreateChapterInput({
    required this.bookId,
    required this.chapterNumber,
    required this.title,
    this.contentText,
    this.coverUrl,
    this.filePath,
    this.status = 'draft',
  });

  final String bookId;
  final int chapterNumber;
  final String title;
  final String? contentText;
  final String? coverUrl;
  final String? filePath;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'book_id': bookId,
      'chapter_number': chapterNumber,
      'title_ar': title,
      'content_text': contentText,
      'cover_url': coverUrl,
      'file_path': filePath,
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

  static const _bookSelect = 'id,author_id,category_id,title_ar,title_en,'
      'description_ar,description_en,cover_url,status,language,views_count,'
      'likes_count,rating_average,ratings_count,chapters_count,published_at,'
      'created_at,updated_at,'
      'author:profiles!books_author_id_fkey(id,display_name,username,avatar_url,bio),'
      'category:categories!books_category_id_fkey(id,slug,name_ar,name_en)';

  static const _chapterSelect = 'id,book_id,chapter_number,title_ar,title_en,'
      'content_text,file_path,audio_path,cover_url,status,published_at,'
      'created_at,updated_at';

  Future<List<Map<String, dynamic>>> getPublishedBooks({int limit = 30}) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('status', 'published')
            .order('published_at', ascending: false)
            .order('created_at', ascending: false)
            .limit(limit);

        return _database.mapList(response);
      },
      message: 'Failed to load books.',
    );
  }

  Future<List<Map<String, dynamic>>> getRecentBooks({int limit = 20}) {
    return getPublishedBooks(limit: limit);
  }

  Future<Map<String, dynamic>?> getBookById(String bookId) {
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
            .order('created_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to load author books.',
    );
  }

  Future<List<Map<String, dynamic>>> getBooksByCategory(String categoryId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.books)
            .select(_bookSelect)
            .eq('category_id', categoryId)
            .eq('status', 'published')
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
            .or(
              'title_ar.ilike.$pattern,'
              'title_en.ilike.$pattern,'
              'description_ar.ilike.$pattern,'
              'description_en.ilike.$pattern',
            )
            .order('published_at', ascending: false);

        return _database.mapList(response);
      },
      message: 'Failed to search books.',
    );
  }

  Future<List<Map<String, dynamic>>> getBookChapters(String bookId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.chapters)
            .select(_chapterSelect)
            .eq('book_id', bookId)
            .eq('status', 'published')
            .order('chapter_number')
            .order('created_at');

        return _database.mapList(response);
      },
      message: 'Failed to load chapters.',
    );
  }

  Future<Map<String, dynamic>?> getChapterById(String chapterId) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.chapters)
            .select('$_chapterSelect,book:books(*)')
            .eq('id', chapterId)
            .maybeSingle();

        return _database.nullableMap(response);
      },
      message: 'Failed to load chapter.',
    );
  }

  Future<Map<String, dynamic>> createBook(CreateBookInput input) {
    return _database.run(
      () async {
        await _requireCurrentUserAsAuthor(input.authorId);
        final response = await _database
            .table(SupabaseTables.books)
            .insert(input.toJson())
            .select(_bookSelect)
            .single();

        return _database.map(response);
      },
      message: 'Failed to create book.',
    );
  }

  Future<Map<String, dynamic>> createChapter(CreateChapterInput input) {
    return _database.run(
      () async {
        await _requireBookOwnership(input.bookId);
        final response = await _database
            .table(SupabaseTables.chapters)
            .insert(input.toJson())
            .select(_chapterSelect)
            .single();

        return _database.map(response);
      },
      message: 'Failed to create chapter.',
    );
  }

  Future<Map<String, dynamic>> updateBook(
    String bookId,
    Map<String, dynamic> fields,
  ) {
    return _database.run(
      () async {
        await _requireBookOwnership(bookId);
        final response = await _database
            .table(SupabaseTables.books)
            .update(<String, dynamic>{
              ...fields,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }..removeWhere((_, value) => value == null))
            .eq('id', bookId)
            .select(_bookSelect)
            .single();

        return _database.map(response);
      },
      message: 'Failed to update book.',
    );
  }

  Future<void> softDeleteBook(String bookId) {
    return _database.run(
      () async {
        await _requireBookOwnership(bookId);
        await _database.table(SupabaseTables.books).update(<String, dynamic>{
          'status': 'archived',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', bookId);
      },
      message: 'Failed to delete book.',
    );
  }

  Future<Map<String, dynamic>> updateChapter(
    String chapterId,
    Map<String, dynamic> fields,
  ) {
    return _database.run(
      () async {
        final chapter = await _getOwnedChapter(chapterId);
        final response = await _database
            .table(SupabaseTables.chapters)
            .update(<String, dynamic>{
              ...fields,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }..removeWhere((_, value) => value == null))
            .eq('id', chapter['id'] as String)
            .eq('book_id', chapter['book_id'] as String)
            .select(_chapterSelect)
            .single();

        return _database.map(response);
      },
      message: 'Failed to update chapter.',
    );
  }

  Future<void> deleteChapter(String chapterId) {
    return _database.run(
      () async {
        final chapter = await _getOwnedChapter(chapterId);
        await _database
            .table(SupabaseTables.chapters)
            .delete()
            .eq('id', chapter['id'] as String)
            .eq('book_id', chapter['book_id'] as String);
      },
      message: 'Failed to delete chapter.',
    );
  }

  Future<void> _requireCurrentUserAsAuthor(String authorId) async {
    final user = _database.client.auth.currentUser;
    if (user == null) {
      throw const AppSessionException('Sign in before managing novels.');
    }
    if (user.id != authorId) {
      throw const AppAuthException('Cannot create a novel for another author.');
    }
  }

  Future<void> _requireBookOwnership(String bookId) async {
    final book = await _bookForOwnership(bookId);
    final user = _database.client.auth.currentUser;
    final profile = await _currentProfile();
    final role = (profile?['role'] ?? 'reader').toString();
    if (role == 'admin') return;
    if (user == null || book['author_id'] != user.id) {
      throw const AppAuthException('You do not own this novel.');
    }
  }

  Future<Map<String, dynamic>> _getOwnedChapter(String chapterId) async {
    final response = await _database
        .table(SupabaseTables.chapters)
        .select('id,book_id')
        .eq('id', chapterId)
        .maybeSingle();
    final chapter = _database.nullableMap(response);
    if (chapter == null) {
      throw const AppDatabaseException('Chapter not found.');
    }
    await _requireBookOwnership(chapter['book_id'] as String);
    return chapter;
  }

  Future<Map<String, dynamic>> _bookForOwnership(String bookId) async {
    final response = await _database
        .table(SupabaseTables.books)
        .select('id,author_id')
        .eq('id', bookId)
        .maybeSingle();
    final book = _database.nullableMap(response);
    if (book == null) {
      throw const AppDatabaseException('Novel not found.');
    }
    return book;
  }

  Future<Map<String, dynamic>?> _currentProfile() async {
    final user = _database.client.auth.currentUser;
    if (user == null) return null;
    final response = await _database
        .table(SupabaseTables.profiles)
        .select('id,role')
        .eq('id', user.id)
        .maybeSingle();
    return _database.nullableMap(response);
  }
}
