import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Utils/ApiUtils.dart';
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

  static const bool _enableLegacyPublicContent = bool.fromEnvironment(
    'ENABLE_LEGACY_PUBLIC_CONTENT',
    defaultValue: false,
  );

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

  Future<Map<String, dynamic>> homeDetails() async {
    try {
      final response = await _supabaseHomeDetails();
      if (_hasHomeContent(response)) {
        return response;
      }
    } catch (_) {
      // Production reader content should come from Supabase so every visible
      // book can be checked against pdf_files before opening the reader.
    }

    if (_enableLegacyPublicContent) {
      return _legacyPublicHomeDetails();
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
      final categoryId = _asInt(category['id']);
      final books = categoryId == null
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

  Future<Map<String, dynamic>> _legacyPublicHomeDetails() async {
    final response = await http
        .get(Uri.parse(ApiUtils.ALL_HOME_CATEGORIES_API))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      return <String, dynamic>{
        'status': response.statusCode,
        'message': 'Unable to load public home content.',
      };
    }

    final decoded = json.decode(response.body);
    final decodedMap = _asMap(decoded);
    if (decodedMap == null) {
      return <String, dynamic>{
        'status': 500,
        'message': 'Invalid public home response.',
      };
    }

    return _normalizeLegacyHomeResponse(decodedMap);
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

  Map<String, dynamic> _normalizeLegacyHomeResponse(
    Map<String, dynamic> response,
  ) {
    final data = _asMap(response['data']);
    if (data == null) {
      return response;
    }

    final normalizedResponse = Map<String, dynamic>.from(response);
    final normalizedData = Map<String, dynamic>.from(data);
    normalizedData['slider'] = _normalizeLegacyRecentBooks(data['slider']);
    normalizedData['recentlyPublishBooks'] =
        _normalizeLegacyRecentBooks(data['recentlyPublishBooks']);
    normalizedResponse['data'] = normalizedData;
    return normalizedResponse;
  }

  List<Map<String, dynamic>> _normalizeLegacyRecentBooks(dynamic value) {
    if (value is! List) {
      return <Map<String, dynamic>>[];
    }

    return value.map((item) {
      final row = _asMap(item) ?? <String, dynamic>{};
      final normalized = Map<String, dynamic>.from(row);
      final bookId = _asInt(normalized['book_id']);
      if (bookId != null && bookId > 0) {
        normalized['id'] = bookId;
      }
      if (!_hasListItems(normalized['categories'])) {
        normalized['categories'] = <Map<String, dynamic>>[
          <String, dynamic>{
            'id': _asInt(normalized['category_id']) ?? 0,
            'title': '',
            'image_path': '',
          },
        ];
      }
      if (!_hasListItems(normalized['user'])) {
        normalized['user'] = <Map<String, dynamic>>[
          <String, dynamic>{
            'id': _asInt(normalized['user_id']) ?? 0,
            'username': '',
            'profile_path': '',
            'background_path': '',
          },
        ];
      }
      return normalized;
    }).toList();
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
      final book = await _books.getBookById(bookId);
      if (book != null) {
        var isSaved = false;
        try {
          isSaved = await _favorites.isFavorite(bookId);
        } catch (_) {
          isSaved = false;
        }

        return <String, dynamic>{
          'status': 200,
          'data': <String, dynamic>{
            'bookId': _asInt(book['id']) ?? 0,
            'bookTitle': _asString(book['title']),
            'image': _asString(book['cover_image_url']),
            'bookDescription': _asString(book['description']),
            'user_id': _legacyUserId(book),
            'author_name': _authorName(book),
            'userimage': _authorProfileImage(book),
            'category_id': _asInt(book['category_id']) ?? 0,
            'catgoryTitle': _categoryTitle(book),
            'payment_status': _asInt(book['payment_status']) ?? 1,
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
            'image_path': _asString(book['cover_image_path']),
          },
        };
      }
    } catch (_) {
      // Fall through to public home data below.
    }

    return _legacyPublicBookDetails(bookId);
  }

  Future<Map<String, dynamic>> bookPdfFiles(int bookId) async {
    final rows = await _books.getBookPdfFiles(bookId);
    final readableRows = rows.where(_hasReadablePdfSource).toList();
    final pdfFiles = await Future.wait(readableRows.map(_legacyPdfFile));

    return <String, dynamic>{
      'status': 200,
      'success': 'PDF files loaded',
      'data': pdfFiles,
    };
  }

  Future<bool> hasReadableBook(int bookId) async {
    final rows = await _books.getBookPdfFiles(bookId);
    return rows.any(_hasReadablePdfSource);
  }

  Future<Map<String, dynamic>> categoryBooks(int categoryId) async {
    final rows = await _books.getBooksByCategory(categoryId);
    return <String, dynamic>{
      'status': 200,
      'data': rows.map(_legacyRecentBook).toList(),
    };
  }

  Future<void> saveBook(int bookId) {
    return _favorites.addFavorite(bookId);
  }

  Future<void> removeSavedBook(int bookId) {
    return _favorites.removeFavorite(bookId);
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
        await _database.table(SupabaseTables.bookReactions).upsert(
          <String, dynamic>{
            'user_id': userId,
            'book_id': bookId,
            'reaction': reaction,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          },
        );
      },
      message: 'Failed to save book reaction.',
    );
  }

  Future<Map<String, dynamic>> _legacyPublicBookDetails(int bookId) async {
    if (!_enableLegacyPublicContent) {
      return <String, dynamic>{
        'status': 404,
        'message': 'Book not found in Supabase.',
      };
    }

    final home = await _legacyPublicHomeDetails();
    final data = _asMap(home['data']);
    final match = data == null ? null : _findPublicHomeBook(data, bookId);
    if (match == null) {
      return <String, dynamic>{
        'status': 404,
        'message': 'Book not found',
      };
    }

    return <String, dynamic>{
      'status': 200,
      'data': <String, dynamic>{
        'bookId': bookId,
        'bookTitle':
            _asString(match['bookTitle'], fallback: _asString(match['title'])),
        'image': _asString(match['image']),
        'bookDescription': _asString(match['description']),
        'user_id': _asInt(match['user_id']) ?? 0,
        'author_name': _publicAuthorName(match),
        'userimage': '',
        'category_id': _asInt(match['category_id']) ?? 0,
        'catgoryTitle': _publicCategoryTitle(match),
        'payment_status': _asInt(match['payment_status']) ?? 1,
        'publication': 0,
        'subscription': 0,
        'BookView': 0,
        'BookLike': 0,
        'BookDisLike': 0,
        'status': <String, dynamic>{'status': 0},
        'gifts': 0,
        'advertisment_links': <Map<String, dynamic>>[],
        'book_saved': false,
        'book_subscription': false,
        'image_path':
            _asString(match['image_path'], fallback: _asString(match['image'])),
      },
    };
  }

  Map<String, dynamic>? _findPublicHomeBook(
    Map<String, dynamic> data,
    int bookId,
  ) {
    for (final source in <dynamic>[
      data['slider'],
      data['recentlyPublishBooks'],
    ]) {
      final match = _findBookInList(source, bookId);
      if (match != null) {
        return match;
      }
    }

    final categoryBooks = data['categoryBooks'];
    if (categoryBooks is List) {
      for (final category in categoryBooks) {
        final categoryRow = _asMap(category);
        final match = _findBookInList(categoryRow?['books'], bookId);
        if (match != null) {
          return match;
        }
      }
    }
    return null;
  }

  Map<String, dynamic>? _findBookInList(dynamic value, int bookId) {
    if (value is! List) {
      return null;
    }
    for (final item in value) {
      final row = _asMap(item);
      if (row != null && _asInt(row['id']) == bookId) {
        return row;
      }
    }
    return null;
  }

  String _publicAuthorName(Map<String, dynamic> book) {
    final user = _asMapList(book['user']);
    if (user.isNotEmpty) {
      return _asString(user.first['username']);
    }
    return _asString(book['author_name']);
  }

  String _publicCategoryTitle(Map<String, dynamic> book) {
    final categories = _asMapList(book['categories']);
    if (categories.isNotEmpty) {
      return _asString(categories.first['title']);
    }
    return '';
  }

  Map<String, dynamic> _legacyCategoryBook(
    Map<String, dynamic> category,
    Iterable<Map<String, dynamic>> books,
  ) {
    return <String, dynamic>{
      'id': _asInt(category['id']) ?? 0,
      'title': _asString(category['title']),
      'titleAr': _asString(category['title_ar']),
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
      'id': _asInt(book['id']) ?? 0,
      'bookTitle': _asString(book['title']),
      'description': _asString(book['description']),
      'payment_status': _asInt(book['payment_status']) ?? 1,
      'image': _asString(book['cover_image_url']),
      'author_name': _authorName(book),
    };
  }

  Map<String, dynamic> _legacyRecentBook(Map<String, dynamic> book) {
    final category = _asMap(book['category']);
    return <String, dynamic>{
      'id': _asInt(book['id']) ?? 0,
      'title': _asString(book['title']),
      'description': _asString(book['description']),
      'category_id': _asInt(book['category_id']) ?? 0,
      'subcategory_id': _asInt(book['subcategory_id']) ?? 0,
      'payment_status': _asInt(book['payment_status']) ?? 1,
      'user_id': _legacyUserId(book),
      'lesson_id': null,
      'image': _asString(book['cover_image_url'],
          fallback: _asString(book['cover_image_path'])),
      'status': _asString(book['status']),
      'is_active': _boolAsInt(book['is_active']),
      'is_seen': 0,
      'language': _legacyLanguage(book['language']),
      'created_by': null,
      'updated_by': null,
      'deleted_by': null,
      'created_at': _asString(book['created_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'updated_at': _asString(book['updated_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'image_path': _asString(book['cover_image_url'],
          fallback: _asString(book['cover_image_path'])),
      'categories': category == null
          ? <Map<String, dynamic>>[]
          : [_legacyCategory(category)],
      'user': [_legacyBookUser(book)],
    };
  }

  Map<String, dynamic> _legacySearchCategory(Map<String, dynamic> category) {
    return <String, dynamic>{
      'category_id': _asInt(category['id']) ?? 0,
      'title': _asString(category['title']),
      'titleAr': _asString(category['title_ar']),
      'image': _asString(category['image_url']),
      'is_active': _boolAsInt(category['is_active']),
      'image_path': _asString(category['image_path']),
    };
  }

  Map<String, dynamic> _legacySearchAuthor(Map<String, dynamic> author) {
    final user = _asMap(author['users']);
    final profile = _asMap(user?['profiles']);
    return <String, dynamic>{
      'id':
          _asInt(author['legacy_id']) ?? _positiveHash(_asString(author['id'])),
      'username': _asString(author['pen_name'],
          fallback: _asString(author['display_name'],
              fallback: _asString(user?['username']))),
      'profile_path': _asString(author['profile_image_url'],
          fallback: _asString(profile?['profile_photo_url'])),
      'background_path': _asString(author['background_image_url'],
          fallback: _asString(profile?['background_image_url'])),
    };
  }

  Future<Map<String, dynamic>> _legacyPdfFile(Map<String, dynamic> pdf) async {
    final book = _asMap(pdf['books']);
    final source = _firstNonEmptyString(<dynamic>[
      pdf['file_url'],
      pdf['pdf_url'],
      pdf['url'],
      pdf['file_path'],
      pdf['storage_path'],
    ]);

    return <String, dynamic>{
      'id': _asInt(pdf['id']) ?? 0,
      'book_id': _asInt(pdf['book_id']) ?? 0,
      'user_id': book == null ? 0 : _legacyUserId(book),
      'pdf_status': _asInt(pdf['pdf_status']) ?? 1,
      'image': null,
      'lesson': pdf['lesson'],
      'filename': _asString(pdf['file_name']),
      'status': _asString(pdf['mime_type'], fallback: 'application/pdf'),
      'created_at': _asString(pdf['created_at'],
          fallback: DateTime.now().toUtc().toIso8601String()),
      'updated_at': _asString(pdf['updated_at']),
      'lesson_path': await _resolvePdfUrl(source),
      'book': book == null
          ? <Map<String, dynamic>>[]
          : <Map<String, dynamic>>[
              <String, dynamic>{
                'id': _asInt(book['id']) ?? 0,
                'image': _asString(book['cover_image_url']),
                'is_active': _boolAsInt(book['is_active']),
                'image_path': _asString(book['cover_image_path']),
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
      'id': _asInt(category['id']) ?? 0,
      'title': _asString(category['title']),
      'image_path': _asString(category['image_path']),
    };
  }

  Map<String, dynamic> _legacyBookUser(Map<String, dynamic> book) {
    final author = _asMap(book['authors']);
    final user = _asMap(author?['users']);
    final profile = _asMap(user?['profiles']);
    return <String, dynamic>{
      'id': _legacyUserId(book),
      'username': _authorName(book),
      'profile_path': _asString(author?['profile_image_url'],
          fallback: _asString(profile?['profile_photo_url'])),
      'background_path': _asString(author?['background_image_url'],
          fallback: _asString(profile?['background_image_url'])),
    };
  }

  int _legacyUserId(Map<String, dynamic> book) {
    final author = _asMap(book['authors']);
    final user = _asMap(author?['users']);
    return _asInt(book['owner_user_legacy_id']) ??
        _asInt(user?['legacy_id']) ??
        _positiveHash(_asString(book['owner_user_id'],
            fallback: _asString(author?['user_id'])));
  }

  String _authorName(Map<String, dynamic> book) {
    final author = _asMap(book['authors']);
    final user = _asMap(author?['users']);
    final profile = _asMap(user?['profiles']);
    return _asString(author?['pen_name'],
        fallback: _asString(author?['display_name'],
            fallback: _asString(profile?['display_name'],
                fallback: _asString(user?['username']))));
  }

  String _authorProfileImage(Map<String, dynamic> book) {
    final author = _asMap(book['authors']);
    final user = _asMap(author?['users']);
    final profile = _asMap(user?['profiles']);
    return _asString(author?['profile_image_url'],
        fallback: _asString(profile?['profile_photo_url']));
  }

  String _categoryTitle(Map<String, dynamic> book) {
    final category = _asMap(book['category']);
    return _asString(category?['title']);
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
