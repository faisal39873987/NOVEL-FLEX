import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Provider/UserProvider.dart';
import '../repositories/auth_repository.dart';
import '../repositories/author_repository.dart';
import '../repositories/profile_repository.dart';

class SupabaseAuthFlowService {
  SupabaseAuthFlowService({
    SupabaseAuthRepository? authRepository,
    SupabaseProfileRepository? profileRepository,
    SupabaseAuthorRepository? authorRepository,
  })  : _authRepository = authRepository ?? SupabaseAuthRepository(),
        _profileRepository = profileRepository ?? SupabaseProfileRepository(),
        _authorRepository = authorRepository ?? SupabaseAuthorRepository();

  final SupabaseAuthRepository _authRepository;
  final SupabaseProfileRepository _profileRepository;
  final SupabaseAuthorRepository _authorRepository;

  Session? get currentSession => _authRepository.currentSession;

  User? get currentUser => _authRepository.currentUser;

  bool get hasSession => _authRepository.isSignedIn;

  Stream<AuthState> get authStateChanges => _authRepository.authStateChanges;

  Future<User> loginWithEmail({
    required String email,
    required String password,
    required UserProvider userProvider,
  }) async {
    final user = await _authRepository.loginWithEmail(
      email: email,
      password: password,
    );
    await syncProvider(userProvider);
    return user;
  }

  Future<bool> loginWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) {
    return _authRepository.loginWithOAuth(
      provider: provider,
      redirectTo: redirectTo,
    );
  }

  Future<User> loginWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
    required UserProvider userProvider,
  }) async {
    final user = await _authRepository.loginWithIdToken(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
      nonce: nonce,
    );
    await _upsertSocialProfile(user);
    await syncProvider(userProvider);
    return user;
  }

  Future<User> signUpReader({
    required String email,
    required String password,
    required String username,
    String? phone,
    required UserProvider userProvider,
  }) async {
    final user = await _authRepository.register(
      input: RegisterInput(
        email: email,
        password: password,
        username: username,
        phone: phone,
        role: 'reader',
      ),
    );
    await syncProvider(userProvider);
    return user;
  }

  Future<User> signUpAuthor({
    required String email,
    required String password,
    required String username,
    String? phone,
    String? description,
    required UserProvider userProvider,
  }) async {
    final user = await _authRepository.register(
      input: RegisterInput(
        email: email,
        password: password,
        username: username,
        phone: phone,
        role: 'author',
        profileMetadata: <String, dynamic>{
          'bio': description,
        }..removeWhere((_, value) => value == null),
      ),
    );
    await _profileRepository.upsertProfile(
      userId: user.id,
      displayName: username,
      bio: description,
    );
    await _authorRepository.upsertAuthor(
      userId: user.id,
      penName: username,
      description: description,
    );
    await syncProvider(userProvider);
    return user;
  }

  Future<void> sendPasswordReset({
    required String email,
    String? redirectTo,
  }) {
    return _authRepository.sendPasswordReset(
      email: email,
      redirectTo: redirectTo,
    );
  }

  Future<void> resetPassword(String password) {
    return _authRepository.updatePassword(password);
  }

  Future<void> logout(UserProvider userProvider) async {
    await _authRepository.logout();
    userProvider.clearUserSession();
  }

  Future<void> syncSocialSession(UserProvider userProvider) async {
    final user = currentUser;
    if (user != null) {
      await _upsertSocialProfile(user);
    }
    await syncProvider(userProvider);
  }

  Future<void> syncProvider(UserProvider userProvider) async {
    final session = currentSession;
    final user = currentUser;
    if (session == null || user == null) {
      if (userProvider.IsGuest) {
        return;
      }
      userProvider.clearUserSession();
      return;
    }

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final username = metadata['username']?.toString() ??
        metadata['name']?.toString() ??
        user.email?.split('@').first ??
        '';
    final image = metadata['avatar_url']?.toString() ??
        metadata['picture']?.toString() ??
        '';

    userProvider.setUserEmail(user.email ?? '');
    userProvider.setUserToken(session.accessToken);
    userProvider.setUserName(username);
    userProvider.setUserID(user.id);
    userProvider.setUserImage(image);
    userProvider.setSavedDate(DateTime.now().millisecondsSinceEpoch);
    userProvider.setGuestMode(false);
  }

  Future<void> _upsertSocialProfile(User user) async {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final username = metadata['username']?.toString() ??
        metadata['name']?.toString() ??
        metadata['full_name']?.toString() ??
        user.email?.split('@').first ??
        'reader';
    final image =
        metadata['avatar_url']?.toString() ?? metadata['picture']?.toString();

    await _profileRepository.upsertUser(
      userId: user.id,
      username: username,
      role: 'reader',
    );
    await _profileRepository.upsertProfile(
      userId: user.id,
      displayName: username,
      profilePhotoUrl: image,
    );
  }
}
