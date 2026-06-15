import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../services/supabase_database_service.dart';

class SupabaseProfileRepository {
  SupabaseProfileRepository({SupabaseDatabaseService? database})
      : _database = database ?? SupabaseDatabaseService();

  final SupabaseDatabaseService _database;

  User? get currentAuthUser => _database.client.auth.currentUser;

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = currentAuthUser;
    if (user == null) {
      throw const AppSessionException('No authenticated user.');
    }

    return getUserProfile(user.id);
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) {
    return _database.run(
      () async {
        final profile = await _database
            .table(SupabaseTables.profiles)
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (profile == null) {
          return null;
        }

        return <String, dynamic>{
          ..._database.map(profile),
          'profile': _database.map(profile),
        };
      },
      message: 'Failed to load user profile.',
    );
  }

  Future<Map<String, dynamic>> upsertUser({
    required String userId,
    required String username,
    String? email,
    String? phone,
    String role = 'reader',
    String? fcmToken,
  }) {
    return _database.run(
      () async {
        final response = await _database
            .table(SupabaseTables.profiles)
            .upsert(<String, dynamic>{
              'id': userId,
              'display_name': username,
              'username': username,
              'role': role,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }..removeWhere((_, value) => value == null))
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to save user.',
    );
  }

  Future<Map<String, dynamic>> upsertProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? profilePhotoPath,
    String? profilePhotoUrl,
    String? backgroundImagePath,
    String? backgroundImageUrl,
    String? websiteUrl,
    String? facebookUrl,
    String? instagramUrl,
    String? twitterUrl,
    String? youtubeUrl,
    String? tiktokUrl,
    String? referralCode,
  }) {
    return _database.run(
      () async {
        final payload = <String, dynamic>{
          'id': userId,
          'display_name': displayName,
          'username': displayName,
          'bio': bio,
          'avatar_url': profilePhotoUrl,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }..removeWhere((_, value) => value == null);

        final response = await _database
            .table(SupabaseTables.profiles)
            .upsert(payload)
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to save profile.',
    );
  }

  Future<Map<String, dynamic>> updateProfileFields(
    String userId,
    Map<String, dynamic> fields,
  ) {
    return _database.run(
      () async {
        final payload = <String, dynamic>{
          ..._normalizeProfileFields(fields),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }..removeWhere((_, value) => value == null);

        final response = await _database
            .table(SupabaseTables.profiles)
            .update(payload)
            .eq('id', userId)
            .select()
            .single();

        return _database.map(response);
      },
      message: 'Failed to update profile.',
    );
  }

  Map<String, dynamic> _normalizeProfileFields(Map<String, dynamic> fields) {
    final allowed = <String>{
      'role',
      'display_name',
      'username',
      'avatar_url',
      'bio',
      'preferred_language',
      'is_public',
    };
    final normalized = <String, dynamic>{};
    for (final entry in fields.entries) {
      final key = entry.key == 'profile_photo_url'
          ? 'avatar_url'
          : entry.key == 'profile_photo_path'
              ? 'avatar_url'
              : entry.key;
      if (allowed.contains(key)) {
        normalized[key] = entry.value;
      }
    }
    return normalized;
  }
}
