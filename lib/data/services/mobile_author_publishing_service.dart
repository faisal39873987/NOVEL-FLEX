import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';
import '../repositories/book_repository.dart';
import '../repositories/storage_repository.dart';

class MobilePublishNovelResult {
  const MobilePublishNovelResult({
    required this.book,
    this.coverUploaded = false,
    this.coverSkipped = false,
  });

  final Map<String, dynamic> book;
  final bool coverUploaded;
  final bool coverSkipped;

  String get bookId => (book['id'] ?? '').toString();
}

class MobileAuthorPublishingService {
  MobileAuthorPublishingService({
    SupabaseBookRepository? bookRepository,
    SupabaseStorageRepository? storageRepository,
  })  : _books = bookRepository ?? SupabaseBookRepository(),
        _storage = storageRepository ?? SupabaseStorageRepository();

  static const int _maxCoverBytes = 5 * 1024 * 1024;
  static const double _coverAspectRatio = 2 / 3;
  static const List<int> _targetWidths = <int>[1200, 1000, 800, 600];
  static const List<int> _jpegQualities = <int>[85, 75, 65];

  final SupabaseBookRepository _books;
  final SupabaseStorageRepository _storage;

  Future<MobilePublishNovelResult> publishNovel({
    required String title,
    required String categoryId,
    String? description,
    String? language,
    File? coverFile,
  }) async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) {
      throw const AppSessionException('Sign in before publishing novels.');
    }

    final book = await _books.createBook(
      CreateBookInput(
        authorId: user.id,
        title: title.trim(),
        categoryId: categoryId.trim(),
        description: _blankToNull(description),
        language: _normalizeLanguage(language),
        status: 'published',
      ),
    );

    if (coverFile == null || !await coverFile.exists()) {
      return MobilePublishNovelResult(book: book);
    }

    try {
      final preparedCover = await prepareCoverForUpload(coverFile);
      final updatedBook = await _storage.uploadBookCover(
        bookId: (book['id'] ?? '').toString(),
        file: preparedCover,
      );
      return MobilePublishNovelResult(
        book: updatedBook,
        coverUploaded: true,
      );
    } catch (_) {
      return MobilePublishNovelResult(
        book: book,
        coverSkipped: true,
      );
    }
  }

  Future<File> prepareCoverForUpload(File file) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const AppStorageException('Could not read cover image.');
    }

    final sourceRatio = decoded.width / decoded.height;
    var sourceX = 0;
    var sourceY = 0;
    var sourceWidth = decoded.width;
    var sourceHeight = decoded.height;

    if (sourceRatio > _coverAspectRatio) {
      sourceWidth = (decoded.height * _coverAspectRatio).round();
      sourceX = ((decoded.width - sourceWidth) / 2).round();
    } else if (sourceRatio < _coverAspectRatio) {
      sourceHeight = (decoded.width / _coverAspectRatio).round();
      sourceY = ((decoded.height - sourceHeight) / 2).round();
    }

    final cropped = img.copyCrop(
      decoded,
      sourceX,
      sourceY,
      sourceWidth,
      sourceHeight,
    );

    List<int>? bestBytes;
    for (final targetWidth in _targetWidths) {
      final width = math.min(targetWidth, cropped.width);
      final height = (width / _coverAspectRatio).round();
      final resized = img.copyResize(
        cropped,
        width: width,
        height: height,
        interpolation: img.Interpolation.average,
      );

      for (final quality in _jpegQualities) {
        final jpg = img.encodeJpg(resized, quality: quality);
        bestBytes = jpg;
        if (jpg.length <= _maxCoverBytes) {
          return _writePreparedCover(file, jpg);
        }
      }
    }

    if (bestBytes != null && bestBytes.length <= _maxCoverBytes) {
      return _writePreparedCover(file, bestBytes);
    }
    throw const AppStorageException(
      'Could not prepare cover image under the upload limit.',
    );
  }

  Future<File> _writePreparedCover(File original, List<int> bytes) async {
    final directory = await getTemporaryDirectory();
    final baseName = p.basenameWithoutExtension(original.path);
    final safeName = baseName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final milliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
    final output = File(
      p.join(directory.path, '${milliseconds}_${safeName}_cover.jpg'),
    );
    return output.writeAsBytes(bytes, flush: true);
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _normalizeLanguage(String? value) {
    final language = (value ?? 'ar').trim().toLowerCase();
    if (language.startsWith('arabic') || language.startsWith('ar')) {
      return 'ar';
    }
    if (language.startsWith('english') || language.startsWith('en')) {
      return 'en';
    }
    return language.isEmpty ? 'ar' : language;
  }
}
