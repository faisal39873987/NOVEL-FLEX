import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../../Provider/UserProvider.dart';
import '../../UserAuthScreen/FogetPassword/NewPasswordScreen.dart';
import '../../UserAuthScreen/login_screen.dart';
import '../../data/services/supabase_auth_flow_service.dart';
import '../../tab_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void goToAuthenticatedHome(BuildContext context) {
  Transitioner(
    context: context,
    child: const TabScreen(),
    animation: AnimationType.slideLeft,
    duration: const Duration(milliseconds: 700),
    replacement: true,
    curveType: CurveType.decelerate,
  );
}

void goToLogin(BuildContext context) {
  Transitioner(
    context: context,
    child: const LoginScreen(),
    animation: AnimationType.fadeIn,
    duration: const Duration(milliseconds: 500),
    replacement: true,
    curveType: CurveType.decelerate,
  );
}

Future<void> syncSupabaseSessionToProvider(BuildContext context) async {
  await SupabaseAuthFlowService().syncProvider(context.read<UserProvider>());
}

Future<void> navigateAfterAuthMutation(BuildContext context) async {
  await syncSupabaseSessionToProvider(context);
  final token = context.read<UserProvider>().UserToken;
  if (token != null && token.trim().isNotEmpty) {
    goToAuthenticatedHome(context);
    return;
  }

  goToLogin(context);
}

void showPasswordRecoveryScreen() {
  final navigator = appNavigatorKey.currentState;
  if (navigator == null) return;

  navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => NewPasswordScreen(token: '')),
    (route) => false,
  );
}
