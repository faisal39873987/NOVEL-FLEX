import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/auth_repository.dart';
import '../repositories/author_repository.dart';
import '../repositories/book_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/storage_repository.dart';

class SupabaseSearchResult {
  const SupabaseSearchResult({
    required this.books,
    required this.authors,
    required this.categories,
  });

  final List<Map<String, dynamic>> books;
  final List<Map<String, dynamic>> authors;
  final List<Map<String, dynamic>> categories;
}

class SupabaseIntegrationService {
  SupabaseIntegrationService({
    SupabaseAuthRepository? authRepository,
    SupabaseBookRepository? bookRepository,
    SupabaseAuthorRepository? authorRepository,
    SupabaseCategoryRepository? categoryRepository,
    SupabaseStorageRepository? storageRepository,
  })  : auth = authRepository ?? SupabaseAuthRepository(),
        books = bookRepository ?? SupabaseBookRepository(),
        authors = authorRepository ?? SupabaseAuthorRepository(),
        categories = categoryRepository ?? SupabaseCategoryRepository(),
        storage = storageRepository ?? SupabaseStorageRepository();

  final SupabaseAuthRepository auth;
  final SupabaseBookRepository books;
  final SupabaseAuthorRepository authors;
  final SupabaseCategoryRepository categories;
  final SupabaseStorageRepository storage;

  User? get currentUser => auth.currentUser;

  Session? get currentSession => auth.currentSession;

  bool get isAuthenticated => auth.isSignedIn;

  Future<User> login({
    required String email,
    required String password,
  }) {
    return auth.loginWithEmail(email: email, password: password);
  }

  Future<User> register({
    required RegisterInput input,
    String? emailRedirectTo,
  }) {
    return auth.register(input: input, emailRedirectTo: emailRedirectTo);
  }

  Future<void> resetPassword({
    required String email,
    String? redirectTo,
  }) {
    return auth.sendPasswordReset(email: email, redirectTo: redirectTo);
  }

  Future<void> logout() {
    return auth.logout();
  }

  Future<List<Map<String, dynamic>>> getHomeBooks({int limit = 30}) {
    return books.getPublishedBooks(limit: limit);
  }

  Future<Map<String, dynamic>?> getBook(int bookId) {
    return books.getBookById(bookId);
  }

  Future<List<Map<String, dynamic>>> getBooksByAuthor(String authorId) {
    return books.getBooksByAuthor(authorId);
  }

  Future<List<Map<String, dynamic>>> getBooksByCategory(int categoryId) {
    return books.getBooksByCategory(categoryId);
  }

  Future<List<Map<String, dynamic>>> getAuthors({int limit = 50}) {
    return authors.getAuthors(limit: limit);
  }

  Future<Map<String, dynamic>?> getAuthor(String authorId) {
    return authors.getAuthorById(authorId);
  }

  Future<List<Map<String, dynamic>>> getCategories() {
    return categories.getActiveCategories();
  }

  Future<List<Map<String, dynamic>>> getSubcategories(int categoryId) {
    return categories.getSubcategories(categoryId);
  }

  Future<List<Map<String, dynamic>>> getBookPdfFiles(int bookId) {
    return books.getBookPdfFiles(bookId);
  }

  Future<String> getSecurePdfUrl({
    required String storagePath,
    int expiresInSeconds = 3600,
  }) {
    return storage.getSecurePdfUrl(
      path: storagePath,
      expiresInSeconds: expiresInSeconds,
    );
  }

  Future<SupabaseSearchResult> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const SupabaseSearchResult(
        books: <Map<String, dynamic>>[],
        authors: <Map<String, dynamic>>[],
        categories: <Map<String, dynamic>>[],
      );
    }

    final results = await Future.wait<List<Map<String, dynamic>>>([
      books.searchBooks(trimmed),
      authors.searchAuthors(trimmed),
      categories.searchCategories(trimmed),
    ]);

    return SupabaseSearchResult(
      books: results[0],
      authors: results[1],
      categories: results[2],
    );
  }
}
