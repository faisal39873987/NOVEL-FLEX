import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';
import '../services/supabase_auth_service.dart';

class RegisterInput {
  RegisterInput({
    required this.email,
    required this.password,
    required this.username,
    this.phone,
    this.role = 'reader',
    this.profileMetadata = const <String, dynamic>{},
  });

  final String email;
  final String password;
  final String username;
  final String? phone;
  final String role;
  final Map<String, dynamic> profileMetadata;

  Map<String, dynamic> toAuthMetadata() {
    return <String, dynamic>{
      'username': username,
      'phone': phone,
      'role': role,
      ...profileMetadata,
    }..removeWhere((_, value) => value == null);
  }
}

class SupabaseAuthRepository {
  SupabaseAuthRepository({
    SupabaseAuthService? authService,
    SupabaseClient? client,
  })  : _authService = authService ?? SupabaseAuthService(client: client),
        _client = client ?? SupabaseConfig.client;

  final SupabaseAuthService _authService;
  final SupabaseClient _client;

  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  Session? get currentSession => _authService.currentSession;

  User? get currentUser => _authService.currentUser;

  bool get isSignedIn => _authService.isSignedIn;

  Future<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AppAuthException('Login succeeded without a user session.');
    }

    return user;
  }

  Future<bool> loginWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) {
    return _authService.signInWithOAuth(
      provider: provider,
      redirectTo: redirectTo,
    );
  }

  Future<User> loginWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  }) async {
    final response = await _authService.signInWithIdToken(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
      nonce: nonce,
    );

    final user = response.user;
    if (user == null) {
      throw const AppAuthException('Social login succeeded without a user.');
    }

    return user;
  }

  Future<User> register({
    required RegisterInput input,
    String? emailRedirectTo,
  }) async {
    final response = await _authService.registerWithEmail(
      email: input.email,
      password: input.password,
      data: input.toAuthMetadata(),
      emailRedirectTo: emailRedirectTo,
    );

    final user = response.user;
    if (user == null) {
      throw const AppAuthException('Registration did not return a user.');
    }

    await _upsertProfile(user, input);

    return user;
  }

  Future<void> sendPasswordReset({
    required String email,
    String? redirectTo,
  }) {
    return _authService.sendPasswordReset(
      email: email,
      redirectTo: redirectTo,
    );
  }

  Future<void> updatePassword(String password) async {
    await _authService.updatePassword(password);
  }

  Future<void> logout() {
    return _authService.signOut();
  }

  Future<void> deleteAccount() {
    return _authService.deleteAccount();
  }

  Future<void> _upsertProfile(User user, RegisterInput input) async {
    await _client.from('profiles').upsert(<String, dynamic>{
          'id': user.id,
          'display_name': input.username,
          'username': input.username,
          'role': input.role,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
          ...input.profileMetadata,
        }..removeWhere((_, value) => value == null));
  }
}
