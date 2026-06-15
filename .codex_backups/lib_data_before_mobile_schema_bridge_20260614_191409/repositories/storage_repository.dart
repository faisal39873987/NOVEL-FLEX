import 'dart:io';

import '../services/supabase_database_service.dart';
import '../services/supabase_storage_service.dart';

class SupabaseStorageRepository {
  SupabaseStorageRepository({
    SupabaseStorageService? storage,
    SupabaseDatabaseService? database,
  })  : _storage = storage ?? SupabaseStorageService(),
        _database = database ?? SupabaseDatabaseService();

  final SupabaseStorageService _storage;
  final SupabaseDatabaseService _database;

  Future<Map<String, dynamic>> uploadBookCover({
    required int bookId,
    required File file,
  }) async {
    final upload = await _storage.uploadBookCover(
      bookId: bookId,
      file: file,
    );

    final response = await _database
        .table(SupabaseTables.books)
        .update(<String, dynamic>{
          'cover_image_path': upload.path,
          'cover_image_url': upload.publicUrl,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', bookId)
        .select()
        .single();

    return _database.map(response);
  }

  Future<Map<String, dynamic>> uploadAuthorProfileImage({
    required String userId,
    required File file,
  }) async {
    final upload = await _storage.uploadAuthorImage(
      authorId: userId,
      file: file,
    );

    return _updateProfileImageFields(
      userId: userId,
      fields: <String, dynamic>{
        'profile_photo_path': upload.path,
        'profile_photo_url': upload.publicUrl,
      },
    );
  }

  Future<Map<String, dynamic>> uploadAuthorBackgroundImage({
    required String userId,
    required File file,
  }) async {
    final upload = await _storage.uploadAuthorImage(
      authorId: userId,
      file: file,
      background: true,
    );

    return _updateProfileImageFields(
      userId: userId,
      fields: <String, dynamic>{
        'background_image_path': upload.path,
        'background_image_url': upload.publicUrl,
      },
    );
  }

  Future<SupabaseStorageUpload> uploadPdfFile({
    required int bookId,
    required String chapterId,
    required File file,
  }) {
    return _storage.uploadPdfFile(
      bookId: bookId,
      chapterId: chapterId,
      file: file,
    );
  }

  Future<String> getSecureBookCoverUrl({
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _storage.createSignedDownloadUrl(
      bucket: SupabaseStorageBuckets.bookCovers,
      path: path,
      expiresInSeconds: expiresInSeconds,
    );
  }

  Future<String> getSecureAuthorImageUrl({
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _storage.createSignedDownloadUrl(
      bucket: SupabaseStorageBuckets.authorImages,
      path: path,
      expiresInSeconds: expiresInSeconds,
    );
  }

  Future<String> getSecurePdfUrl({
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _storage.createSignedDownloadUrl(
      bucket: SupabaseStorageBuckets.pdfFiles,
      path: path,
      expiresInSeconds: expiresInSeconds,
    );
  }

  Future<void> deleteBookCover(String path) {
    return _storage.deleteFile(
      bucket: SupabaseStorageBuckets.bookCovers,
      path: path,
    );
  }

  Future<void> deleteAuthorImage(String path) {
    return _storage.deleteFile(
      bucket: SupabaseStorageBuckets.authorImages,
      path: path,
    );
  }

  Future<void> deletePdfFile(String path) {
    return _storage.deleteFile(
      bucket: SupabaseStorageBuckets.pdfFiles,
      path: path,
    );
  }

  Future<Map<String, dynamic>> _updateProfileImageFields({
    required String userId,
    required Map<String, dynamic> fields,
  }) async {
    final response = await _database
        .table(SupabaseTables.profiles)
        .update(<String, dynamic>{
          ...fields,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', userId)
        .select()
        .single();

    return _database.map(response);
  }
}
