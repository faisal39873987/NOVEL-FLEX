import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/errors/app_exception.dart';

class SupabaseAuthService {
  SupabaseAuthService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => currentSession != null && currentUser != null;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guardAuthCall(
      () => _auth.signInWithPassword(
        email: email.trim(),
        password: password,
      ),
    );
  }

  Future<bool> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) {
    return _guardAuthCall(
      () => _auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
      ),
    );
  }

  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  }) {
    return _guardAuthCall(
      () => _auth.signInWithIdToken(
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
        nonce: nonce,
      ),
    );
  }

  Future<AuthResponse> registerWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
    String? emailRedirectTo,
  }) {
    return _guardAuthCall(
      () => _auth.signUp(
        email: email.trim(),
        password: password,
        data: data,
        emailRedirectTo: emailRedirectTo,
      ),
    );
  }

  Future<void> sendPasswordReset({
    required String email,
    String? redirectTo,
  }) {
    return _guardVoidAuthCall(
      () => _auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: redirectTo,
      ),
    );
  }

  Future<UserResponse> updatePassword(String password) {
    return _guardAuthCall(
      () => _auth.updateUser(
        UserAttributes(password: password),
      ),
    );
  }

  Future<void> signOut() {
    return _guardVoidAuthCall(_auth.signOut);
  }

  Future<T> _guardAuthCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on AuthException catch (error) {
      throw AppAuthException(error.message, cause: error);
    } catch (error) {
      throw AppAuthException('Authentication request failed.', cause: error);
    }
  }

  Future<void> _guardVoidAuthCall(Future<void> Function() call) async {
    try {
      await call();
    } on AuthException catch (error) {
      throw AppAuthException(error.message, cause: error);
    } catch (error) {
      throw AppAuthException('Authentication request failed.', cause: error);
    }
  }
}
