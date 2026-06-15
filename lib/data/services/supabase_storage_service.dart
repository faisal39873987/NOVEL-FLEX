import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';

class SupabaseStorageBuckets {
  static const bookCovers = 'book-covers';
  static const chapterCovers = 'chapter-covers';
  static const authorImages = 'author-images';
  static const pdfFiles = 'chapter-files';
}

class SupabaseStorageUpload {
  const SupabaseStorageUpload({
    required this.bucket,
    required this.path,
    required this.publicUrl,
  });

  final String bucket;
  final String path;
  final String publicUrl;
}

class SupabaseStorageService {
  SupabaseStorageService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  Future<SupabaseStorageUpload> uploadBookCover({
    required String bookId,
    required File file,
    bool upsert = true,
  }) {
    return uploadSecureFile(
      bucket: SupabaseStorageBuckets.bookCovers,
      path: buildBookCoverPath(bookId: bookId, file: file),
      file: file,
      contentType: _contentTypeFor(file, fallback: 'image/jpeg'),
      upsert: upsert,
    );
  }

  Future<SupabaseStorageUpload> uploadAuthorImage({
    required String authorId,
    required File file,
    bool background = false,
    bool upsert = true,
  }) {
    return uploadSecureFile(
      bucket: SupabaseStorageBuckets.authorImages,
      path: buildAuthorImagePath(
        authorId: authorId,
        file: file,
        background: background,
      ),
      file: file,
      contentType: _contentTypeFor(file, fallback: 'image/jpeg'),
      upsert: upsert,
    );
  }

  Future<SupabaseStorageUpload> uploadPdfFile({
    required String bookId,
    required String chapterId,
    required File file,
    bool upsert = false,
  }) {
    return uploadSecureFile(
      bucket: SupabaseStorageBuckets.pdfFiles,
      path: buildPdfPath(bookId: bookId, chapterId: chapterId, file: file),
      file: file,
      contentType: 'application/pdf',
      upsert: upsert,
    );
  }

  Future<SupabaseStorageUpload> uploadSecureFile({
    required String bucket,
    required String path,
    required File file,
    String? contentType,
    bool upsert = false,
  }) {
    return _guardStorageCall(
      () async {
        await _client.storage.from(bucket).upload(
              path,
              file,
              fileOptions: FileOptions(
                cacheControl: '3600',
                contentType: contentType,
                upsert: upsert,
              ),
            );

        return SupabaseStorageUpload(
          bucket: bucket,
          path: path,
          publicUrl: _client.storage.from(bucket).getPublicUrl(path),
        );
      },
      message: 'Failed to upload file.',
    );
  }

  Future<String> createSignedDownloadUrl({
    required String bucket,
    required String path,
    int expiresInSeconds = 3600,
  }) {
    return _guardStorageCall(
      () => _client.storage.from(bucket).createSignedUrl(
            path,
            expiresInSeconds,
          ),
      message: 'Failed to create secure download URL.',
    );
  }

  Future<List<String>> createSignedDownloadUrls({
    required String bucket,
    required List<String> paths,
    int expiresInSeconds = 3600,
  }) {
    return _guardStorageCall(
      () async {
        final results =
            await _client.storage.from(bucket).createSignedUrlsResult(
                  paths,
                  expiresInSeconds,
                );

        return results.map((result) {
          if (result is SignedUrlSuccess) {
            return result.signedUrl;
          }
          if (result is SignedUrlFailure) {
            throw AppStorageException(
              'Failed to create signed URL for ${result.path}: ${result.error}',
            );
          }
          throw AppStorageException(
            'Failed to create signed URL for ${result.path}.',
          );
        }).toList(growable: false);
      },
      message: 'Failed to create secure download URLs.',
    );
  }

  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) {
    return _guardStorageCall(
      () => _client.storage.from(bucket).remove(<String>[path]),
      message: 'Failed to delete file.',
    ).then((_) {});
  }

  String buildBookCoverPath({
    required String bookId,
    required File file,
  }) {
    return 'books/$bookId/covers/${_timestampedFileName(file)}';
  }

  String buildAuthorImagePath({
    required String authorId,
    required File file,
    bool background = false,
  }) {
    final folder = background ? 'backgrounds' : 'profiles';
    return 'authors/$authorId/$folder/${_timestampedFileName(file)}';
  }

  String buildPdfPath({
    required String bookId,
    required String chapterId,
    required File file,
  }) {
    return 'books/$bookId/chapters/$chapterId/${_safeBaseName(file)}';
  }

  Future<T> _guardStorageCall<T>(
    Future<T> Function() operation, {
    required String message,
  }) async {
    try {
      return await operation();
    } catch (error) {
      throw AppStorageException(message, cause: error);
    }
  }

  String _timestampedFileName(File file) {
    final milliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
    return '${milliseconds}_${_safeBaseName(file)}';
  }

  String _safeBaseName(File file) {
    final rawName = p.basename(file.path);
    return rawName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  String _contentTypeFor(File file, {required String fallback}) {
    switch (p.extension(file.path).toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.webp':
        return 'image/webp';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      default:
        return fallback;
    }
  }
}
