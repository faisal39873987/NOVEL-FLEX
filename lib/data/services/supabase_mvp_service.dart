import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/MenuProfileModel.dart' as menu_model;
import '../../Models/StatusCheckModel.dart' as status_model;
import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';
import 'supabase_database_service.dart';

class MvpFeatureDisabledException extends AppException {
  const MvpFeatureDisabledException(String message) : super(message);
}

class SupabaseMvpService {
  SupabaseMvpService({SupabaseDatabaseService? database})
      : _database = database;

  final SupabaseDatabaseService? _database;

  SupabaseDatabaseService get _db => _database ?? SupabaseDatabaseService();

  User? get _currentUser =>
      SupabaseConfig.hasEnvironment ? _db.client.auth.currentUser : null;

  String get _currentUserId {
    final user = _currentUser;
    if (user == null) {
      throw const AppSessionException('No authenticated Supabase session.');
    }
    return user.id;
  }

  Future<status_model.StatusCheckModel> currentStatus() async {
    final profile = await _currentProfile();
    final role = (profile['role'] ?? 'reader').toString();
    final type = role == 'writer' || role == 'admin' ? 'Writer' : 'Reader';
    final accepted = type != 'Writer' ||
        profile['writer_terms_accepted'] != false &&
            profile['agreement_accepted'] != false;

    return status_model.StatusCheckModel(
      status: 200,
      aggrement: accepted,
      data: status_model.Data(
        id: _stableIntId(_currentUserId),
        type: type,
        checkStatus: type == 'Writer' ? 'approved' : 'active',
        profilePath: (profile['avatar_url'] ?? '').toString(),
        backgroundPath: (profile['background_url'] ?? '').toString(),
      ),
    );
  }

  Future<menu_model.MenuProfileModel> currentMenuProfile() async {
    final profile = await _currentProfile();
    final user = _currentUser;
    final role = (profile['role'] ?? 'reader').toString();
    final type = role == 'writer' || role == 'admin' ? 'Writer' : 'Reader';

    return menu_model.MenuProfileModel(
      status: 200,
      data: menu_model.Data(
        id: _stableIntId(_currentUserId),
        username: (profile['display_name'] ??
                profile['username'] ??
                user?.email?.split('@').first ??
                '')
            .toString(),
        email: user?.email ?? '',
        phone: profile['phone'],
        type: type,
        profilePhoto: profile['avatar_url'],
        registerdDate: DateTime.tryParse(
              (profile['created_at'] ?? '').toString(),
            ) ??
            DateTime.now(),
        totalAmount: 0,
        profilePath: (profile['avatar_url'] ?? '').toString(),
        backgroundPath: (profile['background_url'] ?? '').toString(),
      ),
    );
  }

  Future<void> acceptWriterTerms() async {
    await _db.run(
      () async {
        await _db.table(SupabaseTables.profiles).update(<String, dynamic>{
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', _currentUserId);
      },
      message: 'Failed to accept writer terms.',
    );
  }

  Future<int> unreadNotificationCount() async {
    if (_currentUser == null) return 0;
    return _db.run(
      () async {
        final response = await _db
            .table(SupabaseTables.notifications)
            .select('id')
            .eq('user_id', _currentUserId)
            .eq('is_read', false);
        return _db.mapList(response).length;
      },
      message: 'Failed to load notification count.',
    );
  }

  Future<List<Map<String, dynamic>>> notifications() {
    return _db.run(
      () async {
        final response = await _db
            .table(SupabaseTables.notifications)
            .select()
            .eq('user_id', _currentUserId)
            .order('created_at', ascending: false)
            .limit(100);
        return _db.mapList(response);
      },
      message: 'Failed to load notifications.',
    );
  }

  Future<void> markNotificationsRead() {
    return _db.run(
      () async {
        await _db.table(SupabaseTables.notifications).update(<String, dynamic>{
          'is_read': true,
          'read_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('user_id', _currentUserId);
      },
      message: 'Failed to mark notifications as read.',
    );
  }

  Future<bool> isFollowing(String authorUserId) {
    return _db.run(
      () async {
        final response = await _db
            .table(SupabaseTables.follows)
            .select('author_id')
            .eq('follower_id', _currentUserId)
            .eq('author_id', authorUserId)
            .maybeSingle();
        return response != null;
      },
      message: 'Failed to check follow status.',
    );
  }

  Future<void> setFollowing(String authorUserId, bool follow) {
    return _db.run(
      () async {
        if (follow) {
          await _db.table(SupabaseTables.follows).upsert(<String, dynamic>{
            'follower_id': _currentUserId,
            'author_id': authorUserId,
          });
        } else {
          await _db
              .table(SupabaseTables.follows)
              .delete()
              .eq('follower_id', _currentUserId)
              .eq('author_id', authorUserId);
        }
      },
      message: 'Failed to update follow status.',
    );
  }

  Future<int> followerCount(String authorUserId) {
    return _db.run(
      () async {
        final response = await _db
            .table(SupabaseTables.follows)
            .select('follower_id')
            .eq('author_id', authorUserId);
        return _db.mapList(response).length;
      },
      message: 'Failed to load follower count.',
    );
  }

  Future<Map<String, dynamic>> _currentProfile() async {
    if (!SupabaseConfig.hasEnvironment) {
      throw const AppSessionException(
          'Supabase environment is not configured.');
    }

    final response = await _db
        .table(SupabaseTables.profiles)
        .select()
        .eq('id', _currentUserId)
        .maybeSingle();

    if (response == null) {
      return <String, dynamic>{
        'id': _currentUserId,
        'role': 'reader',
        'display_name': _currentUser?.email?.split('@').first ?? '',
      };
    }

    return _db.map(response);
  }

  int _stableIntId(String value) {
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }
}
