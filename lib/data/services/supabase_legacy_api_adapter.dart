import '../repositories/author_repository.dart';
import '../repositories/book_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/favorite_repository.dart';
import 'supabase_storage_service.dart';
import 'supabase_database_service.dart';

class SupabaseLegacyApiAdapter {
  SupabaseLegacyApiAdapter({
    SupabaseBookRepository? bookRepository,
    SupabaseAuthorRepository? authorRepository,
    SupabaseCategoryRepository? categoryRepository,
    SupabaseFavoriteRepository? favoriteRepository,
    SupabaseDatabaseService? database,
  })  : _bookRepository = bookRepository,
        _authorRepository = authorRepository,
        _categoryRepository = categoryRepository,
        _favoriteRepository = favoriteRepository,
        _databaseOverride = database;

  final SupabaseBookRepository? _bookRepository;
  final SupabaseAuthorRepository? _authorRepository;
  final SupabaseCategoryRepository? _categoryRepository;
  final SupabaseFavoriteRepository? _favoriteRepository;
  final SupabaseDatabaseService? _databaseOverride;

  late final SupabaseDatabaseService _database =
      _databaseOverride ?? SupabaseDatabaseService();
  late final SupabaseBookRepository _books =
      _bookRepository ?? SupabaseBookRepository(database: _database);
  late final SupabaseAuthorRepository _authors =
      _authorRepository ?? SupabaseAuthorRepository(database: _database);
  late final SupabaseCategoryRepository _categories =
      _categoryRepository ?? SupabaseCategoryRepository(database: _database);
  late final SupabaseFavoriteRepository _favorites =
      _favoriteRepository ?? SupabaseFavoriteRepository(database: _database);

  int legacyBookIdFromUuid(String bookId) => _positiveHash(bookId);

  Future<Map<String, dynamic>> homeDetails() async {
    try {
      final response = await _supabaseHomeDetails();
      if (_hasHomeContent(response)) {
        return response;
      }
    } catch (_) {
      // Production reader content should come from Supabase so every visible
      // book can be checked against chapters before opening the reader.
    }

    return _emptyHomeDetails();
  }

  Map<String, dynamic> _emptyHomeDetails() {
    return <String, dynamic>{
      'status': 200,
      'data': <String, dynamic>{
        'slider': <Map<String, dynamic>>[],
        'recentlyPublishBooks': <Map<String, dynamic>>[],
        'categoryBooks': <Map<String, dynamic>>[],
      },
    };
  }

  Future<Map<String, dynamic>> _supabaseHomeDetails() async {
    final categories = await _categories.getActiveCategories();
    final recentBooks = await _books.getRecentBooks(limit: 20);
    final categoryBooks = <Map<String, dynamic>>[];

    for (final category in categories.take(8)) {
      final categoryId = _asString(category['id']);
      final books = categoryId.isEmpty
          ? <Map<String, dynamic>>[]
          : await _books.getBooksByCategory(categoryId);
      categoryBooks.add(_legacyCategoryBook(category, books.take(10)));
    }

    return <String, dynamic>{
      'status': 200,
      'data': <String, dynamic>{
        'slider': recentBooks.take(5).map(_legacyRecentBook).toList(),
        'recentlyPublishBooks': recentBooks.map(_legacyRecentBook).toList(),
        'categoryBooks': categoryBooks,
      },
    };
  }

  bool _hasHomeContent(Map<String, dynamic> response) {
    if (_asInt(response['status']) != 200) {
      return false;
    }
    final data = _asMap(response['data']);
    if (data == null) {
      return false;
    }
    return _hasListItems(data['slider']) ||
        _hasListItems(data['recentlyPublishBooks']) ||
        _hasCategoryBooks(data['categoryBooks']);
  }

  bool _hasListItems(dynamic value) => value is List && value.isNotEmpty;

  bool _hasCategoryBooks(dynamic value) {
    if (value is! List) {
      return false;
    }
    for (final item in value) {
      final row = _asMap(item);
      if (_hasListItems(row?['books'])) {
        return true;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> searchCategories(String query) async {
    final rows = query.trim().isEmpty
        ? await _categories.getActiveCategories()
        : await _categories.searchCategories(query);
    return <String, dynamic>{
      'status': 200,
      'data': rows.map(_legacySearchCategory).toList(),
    };
  }

  Future<Map<String, dynamic>> searchAuthors(String query) async {
    final rows = query.trim().isEmpty
        ? await _authors.getAuthors(limit: 100)
        : await _authors.searchAuthors(query, limit: 100);
    return <String, dynamic>{
      'status': 200,
      'data': rows.map(_legacySearchAuthor).toList(),
    };
  }

  Future<Map<String, dynamic>> bookDetails(int bookId) async {
    try {
      final bookUuid = await _resolveBookUuid(bookId);
      final book = bookUuid == null ? null : await _books.getBookById(bookUuid);
      if (book != null) {
        var isSaved = false;
        try {
          isSaved = await _favorites.isFavorite(_asString(book['id']));
        } catch (_) {
          isSaved = false;
        }

        return <String, dynamic>{
          'status': 200,
          'data': <String, dynamic>{
            'bookId': _legacyBookId(book),
            'bookTitle': _bookTitle(book),
            'image': _bookCover(book),
            'bookDescription': _bookDescription(book),
            'user_id': _legacyUserId(book),
            'author_name': _authorName(book),
            'userimage': _authorProfileImage(book),
            'category_id': _legacyCategoryId(_asMap(book['category'])),
            'catgoryTitle': _categoryTitle(book),
            'payment_status': 1,
            'publication': 0,
            'subscription': 0,
            'BookView': _asInt(book['views_count']) ?? 0,
            'BookLike': _asInt(book['likes_count']) ?? 0,
            'BookDisLike': _asInt(book['dislikes_count']) ?? 0,
            'status': <String, dynamic>{'status': 0},
            'gifts': 0,
            'advertisment_links': <Map<String, dynamic>>[],
            'book_saved': isSaved,
            'book_subscription': false,
            'image_path': _bookCover(book),
          },
        };
      }
    } catch (_) {
      // Fall through to public home data below.
    }

    return _legacyPublicBookDetails(bookId);
  }

  Future<Map<String, dynamic>> bookPdfFiles(int bookId) async {
    final bookUuid = await _resolveBookUuid(bookId);
    final rows = bookUuid == null
        ? <Map<String, dynamic>>[]
        : await _books.getBookChapters(bookUuid);
    final chapters = await Future.wait(rows.map(_legacyPdfFile));

    return <String, dynamic>{
      'status': 200,
      'success': 'Chapters loaded',
      'data': chapters,
    };
  }

  Future<bool> hasReadableBook(int bookId) async {
    final bookUuid = await _resolveBookUuid(bookId);
    if (bookUuid == null) {
      return false;
    }
    final rows = await _books.getBookChapters(bookUuid);
    return rows.isNotEmpty;
  }

  Future<Map<String, dynamic>> categoryBooks(int categoryId) async {
    final categoryUuid = await _resolveCategoryUuid(categoryId);
    final rows = categoryUuid == null
        ? <Map<String, dynamic>>[]
        : await _books.getBooksByCategory(categoryUuid);
    return <String, dynamic>{
      'status': 200,
      'data': rows.map(_legacyRecentBook).toList(),
    };
  }

  Future<void> saveBook(int bookId) async {
    final bookUuid = await _resolveBookUuid(bookId);
    if (bookUuid == null) {
      return;
    }
    await _favorites.addFavorite(bookUuid);
  }

  Future<void> removeSavedBook(int bookId) async {
    final bookUuid = await _resolveBookUuid(bookId);
    if (bookUuid == null) {
      return;
    }
    await _favorites.removeFavorite(bookUuid);
  }

  Future<void> setBookReaction({
    required int bookId,
    required int reaction,
  }) {
    return _database.run(
      () async {
        final userId = _database.client.auth.currentUser?.id;
        if (userId == null) {
          return;
        }
        // MVP production schema does not expose book_reactions yet.
        // Keep this as a no-op so mobile UI never crashes on unavailable
        // monetization/social-future tables.
      },
      message: 'Failed to save book reaction.',
    );
  }

  Future<Map<String, dynamic>> _legacyPublicBookDetails(int bookId) async {
    return <String, dynamic>{
      'status': 404,
      'message': 'Book $bookId was not found in Supabase.',
    };
  }

  Map<String, dynamic> _legacyCategoryBook(
    Map<String, dynamic> category,
    Iterable<Map<String, dynamic>> books,
  ) {
    return <String, dynamic>{
      'id': _legacyCategoryId(category),
      'title': _asString(category['name_en'],
          fallback: _asString(category['name_ar'])),
      'titleAr': _asString(category['name_ar']),
      'is_active': _boolAsInt(category['is_active']),
      'image': _asString(category['image_url']),
      'created_at': _asString(category['created_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'updated_at': _asString(category['updated_at']),
      'created_by': 0,
      'updated_by': null,
      'deleted_by': null,
      'books': books.map(_legacyCategoryBookItem).toList(),
    };
  }

  Map<String, dynamic> _legacyCategoryBookItem(Map<String, dynamic> book) {
    return <String, dynamic>{
      'id': _legacyBookId(book),
      'bookTitle': _bookTitle(book),
      'description': _bookDescription(book),
      'payment_status': 1,
      'image': _bookCover(book),
      'author_name': _authorName(book),
    };
  }

  Map<String, dynamic> _legacyRecentBook(Map<String, dynamic> book) {
    final category = _asMap(book['category']);
    return <String, dynamic>{
      'id': _legacyBookId(book),
      'title': _bookTitle(book),
      'description': _bookDescription(book),
      'category_id': _legacyCategoryId(category),
      'subcategory_id': _asInt(book['subcategory_id']) ?? 0,
      'payment_status': 1,
      'user_id': _legacyUserId(book),
      'lesson_id': null,
      'image': _bookCover(book),
      'status': _asString(book['status']),
      'is_active': book['status'] == 'published' ? 1 : 0,
      'is_seen': 0,
      'language': _legacyLanguage(book['language']),
      'created_by': null,
      'updated_by': null,
      'deleted_by': null,
      'created_at': _asString(book['created_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'updated_at': _asString(book['updated_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'image_path': _bookCover(book),
      'categories': category == null
          ? <Map<String, dynamic>>[]
          : [_legacyCategory(category)],
      'user': [_legacyBookUser(book)],
    };
  }

  Map<String, dynamic> _legacySearchCategory(Map<String, dynamic> category) {
    return <String, dynamic>{
      'category_id': _legacyCategoryId(category),
      'title': _asString(category['name_en'],
          fallback: _asString(category['name_ar'])),
      'titleAr': _asString(category['name_ar']),
      'image': _asString(category['image_url']),
      'is_active': _boolAsInt(category['is_active']),
      'image_path': _asString(category['image_path']),
    };
  }

  Map<String, dynamic> _legacySearchAuthor(Map<String, dynamic> author) {
    final profile = _asMap(author['profile']);
    return <String, dynamic>{
      'id':
          _asInt(author['legacy_id']) ?? _positiveHash(_asString(author['id'])),
      'username': _asString(author['pen_name'],
          fallback: _asString(profile?['display_name'],
              fallback: _asString(profile?['username']))),
      'profile_path': _asString(profile?['avatar_url']),
      'background_path': '',
    };
  }

  Future<Map<String, dynamic>> _legacyPdfFile(Map<String, dynamic> pdf) async {
    final book = _asMap(pdf['book']);
    final source = _firstNonEmptyString(<dynamic>[
      pdf['file_url'],
      pdf['pdf_url'],
      pdf['url'],
      pdf['file_path'],
      pdf['storage_path'],
    ]);

    return <String, dynamic>{
      'id': _legacyChapterId(pdf),
      'book_id': _positiveHash(_asString(pdf['book_id'])),
      'user_id': book == null ? 0 : _legacyUserId(book),
      'pdf_status': _asInt(pdf['pdf_status']) ?? 1,
      'image': _asString(pdf['cover_url']),
      'lesson': _asString(pdf['title_ar'],
          fallback: _asString(pdf['title_en'],
              fallback: 'الفصل ${_asInt(pdf['chapter_number']) ?? 1}')),
      'filename': _asString(pdf['title_ar']),
      'status': _asString(pdf['status'], fallback: 'text/plain'),
      'created_at': _asString(pdf['created_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'updated_at': _asString(pdf['updated_at']),
      'lesson_path': source.isEmpty
          ? _asString(pdf['content_text'])
          : await _resolvePdfUrl(source),
      'book': book == null
          ? <Map<String, dynamic>>[]
          : <Map<String, dynamic>>[
              <String, dynamic>{
                'id': _legacyBookId(book),
                'image': _bookCover(book),
                'is_active': book['status'] == 'published' ? 1 : 0,
                'image_path': _bookCover(book),
              }
            ],
    };
  }

  bool _hasReadablePdfSource(Map<String, dynamic> pdf) {
    return _firstNonEmptyString(<dynamic>[
      pdf['file_url'],
      pdf['pdf_url'],
      pdf['url'],
      pdf['file_path'],
      pdf['storage_path'],
    ]).isNotEmpty;
  }

  String _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      final text = _asString(value).trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  Future<String> _resolvePdfUrl(String source) async {
    final normalized = source.trim();
    if (normalized.isEmpty || _isAbsoluteUrl(normalized)) {
      return normalized;
    }

    final path = normalized.startsWith('${SupabaseStorageBuckets.pdfFiles}/')
        ? normalized.substring(SupabaseStorageBuckets.pdfFiles.length + 1)
        : normalized;

    try {
      return await SupabaseStorageService().createSignedDownloadUrl(
        bucket: SupabaseStorageBuckets.pdfFiles,
        path: path,
        expiresInSeconds: 3600,
      );
    } catch (_) {
      return SupabaseStorageService().getPublicUrl(
        bucket: SupabaseStorageBuckets.pdfFiles,
        path: path,
      );
    }
  }

  bool _isAbsoluteUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  Map<String, dynamic> _legacyCategory(Map<String, dynamic> category) {
    return <String, dynamic>{
      'id': _legacyCategoryId(category),
      'title': _asString(category['name_ar'],
          fallback: _asString(category['name_en'])),
      'image_path': _asString(category['image_path']),
    };
  }

  Map<String, dynamic> _legacyBookUser(Map<String, dynamic> book) {
    final profile = _asMap(book['author']);
    return <String, dynamic>{
      'id': _legacyUserId(book),
      'username': _authorName(book),
      'profile_path': _asString(profile?['avatar_url']),
      'background_path': '',
    };
  }

  int _legacyUserId(Map<String, dynamic> book) {
    return _positiveHash(_asString(book['author_id']));
  }

  String _authorName(Map<String, dynamic> book) {
    final profile = _asMap(book['author']);
    return _asString(profile?['display_name'],
        fallback: _asString(profile?['username']));
  }

  String _authorProfileImage(Map<String, dynamic> book) {
    final profile = _asMap(book['author']);
    return _asString(profile?['avatar_url']);
  }

  String _categoryTitle(Map<String, dynamic> book) {
    final category = _asMap(book['category']);
    return _asString(category?['name_ar'],
        fallback: _asString(category?['name_en']));
  }

  String _bookTitle(Map<String, dynamic> book) {
    return _asString(book['title_ar'],
        fallback:
            _asString(book['title_en'], fallback: _asString(book['title'])));
  }

  String _bookDescription(Map<String, dynamic> book) {
    return _asString(book['description_ar'],
        fallback: _asString(book['description_en'],
            fallback: _asString(book['description'])));
  }

  String _bookCover(Map<String, dynamic> book) {
    return _asString(book['cover_url'],
        fallback: _asString(book['cover_image_url'],
            fallback: _asString(book['cover_image_path'])));
  }

  int _legacyBookId(Map<String, dynamic> book) {
    return _asInt(book['legacy_id']) ?? _positiveHash(_asString(book['id']));
  }

  int _legacyChapterId(Map<String, dynamic> chapter) {
    return _asInt(chapter['legacy_id']) ??
        _positiveHash(_asString(chapter['id']));
  }

  int _legacyCategoryId(Map<String, dynamic>? category) {
    if (category == null) {
      return 0;
    }
    return _asInt(category['legacy_id']) ??
        _positiveHash(_asString(category['id']));
  }

  Future<String?> _resolveBookUuid(int legacyBookId) async {
    final rows = await _books.getPublishedBooks(limit: 500);
    for (final book in rows) {
      if (_legacyBookId(book) == legacyBookId) {
        return _asString(book['id']);
      }
    }
    return null;
  }

  Future<String?> _resolveCategoryUuid(int legacyCategoryId) async {
    final rows = await _categories.getActiveCategories();
    for (final category in rows) {
      if (_legacyCategoryId(category) == legacyCategoryId) {
        return _asString(category['id']);
      }
    }
    return null;
  }

  String _legacyLanguage(dynamic value) {
    final language = _asString(value).trim().toLowerCase();
    if (language.startsWith('ar')) {
      return 'arb';
    }
    return 'eng';
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) {
      return <Map<String, dynamic>>[];
    }
    return value.map(_asMap).whereType<Map<String, dynamic>>().toList();
  }

  String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }
    final text = value.toString();
    return text == 'null' ? fallback : text;
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(_asString(value));
  }

  int _boolAsInt(dynamic value) {
    if (value is bool) {
      return value ? 1 : 0;
    }
    return _asInt(value) ?? 0;
  }

  int _positiveHash(String value) {
    var hash = 0;
    for (final codeUnit in value.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
    return hash.abs();
  }
}
