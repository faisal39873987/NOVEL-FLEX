import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository.dart';

class SessionController extends ChangeNotifier {
  SessionController(this._authRepository) {
    _session = _authRepository.currentSession;
    _subscription = _authRepository.authStateChanges.listen(_handleAuthState);
  }

  final SupabaseAuthRepository _authRepository;
  StreamSubscription<AuthState>? _subscription;
  Session? _session;

  Session? get session => _session;

  User? get user => _session?.user ?? _authRepository.currentUser;

  bool get isAuthenticated => user != null;

  Future<void> logout() {
    return _authRepository.logout();
  }

  void _handleAuthState(AuthState state) {
    _session = state.session;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
