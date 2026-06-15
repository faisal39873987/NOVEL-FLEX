import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MixScreens/AccountInfoScreen.dart';
import '../MixScreens/FaqScreen.dart';
import '../MixScreens/Uploadscreens/UploadDataScreen.dart';
import '../Provider/UserProvider.dart';
import '../UserAuthScreen/login_screen.dart';
import '../core/config/supabase_config.dart';
import '../data/services/supabase_auth_flow_service.dart';
import '../data/services/supabase_database_service.dart';
import 'phone_design.dart';
import 'phone_widgets.dart';

class PhoneProfileScreen extends StatefulWidget {
  const PhoneProfileScreen({super.key});

  @override
  State<PhoneProfileScreen> createState() => _PhoneProfileScreenState();
}

class _PhoneProfileScreenState extends State<PhoneProfileScreen> {
  bool _darkMode = true;
  bool _loggingOut = false;
  Future<_ProfileMetrics>? _metricsFuture;
  String _metricsKey = '';

  bool _isSignedIn(UserProvider userProvider) {
    if ((userProvider.UserToken ?? '').isNotEmpty) {
      return true;
    }
    return SupabaseConfig.hasEnvironment &&
        SupabaseAuthFlowService().hasSession;
  }

  Future<void> _logout(UserProvider userProvider) async {
    setState(() => _loggingOut = true);
    try {
      if (SupabaseConfig.hasEnvironment) {
        await SupabaseAuthFlowService().logout(userProvider);
      } else {
        userProvider.clearUserSession();
      }
      _metricsFuture = null;
      _metricsKey = '';
    } finally {
      if (mounted) {
        setState(() => _loggingOut = false);
      }
    }
  }

  void _open(Widget child) {
    Transitioner(
      context: context,
      child: child,
      animation: AnimationType.slideLeft,
      duration: const Duration(milliseconds: 420),
      replacement: false,
      curveType: CurveType.decelerate,
    );
  }

  Future<void> _supportEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@novelflex.online',
      query: 'subject=NOVELFLEX Support',
    );
    await launchUrl(uri);
  }

  Future<_ProfileMetrics> _loadMetrics(bool signedIn) async {
    if (!signedIn || !SupabaseConfig.hasEnvironment) {
      return const _ProfileMetrics.empty();
    }

    final client = SupabaseConfig.client;
    final user = client.auth.currentUser;
    if (user == null) {
      return const _ProfileMetrics.empty();
    }

    final results = await Future.wait<int>(<Future<int>>[
      _countRows(SupabaseTables.favorites, 'user_id', user.id),
      _countRows(SupabaseTables.readingProgress, 'user_id', user.id),
      _countRows(SupabaseTables.reviews, 'user_id', user.id),
      _countRows(SupabaseTables.follows, 'follower_id', user.id),
    ]);

    return _ProfileMetrics(
      libraryCount: results[0],
      readingCount: results[1],
      reviewCount: results[2],
      followCount: results[3],
    );
  }

  Future<int> _countRows(String table, String column, String value) async {
    final response =
        await SupabaseConfig.client.from(table).select('id').eq(column, value);
    return (response as List<dynamic>).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoneUiColors.black,
      body: SafeArea(
        bottom: false,
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final signedIn = _isSignedIn(userProvider);
            final currentMetricKey = signedIn
                ? (SupabaseConfig.hasEnvironment
                    ? SupabaseConfig.client.auth.currentUser?.id
                    : userProvider.UserID)
                : 'guest';
            if (_metricsFuture == null || _metricsKey != currentMetricKey) {
              _metricsKey = currentMetricKey ?? '';
              _metricsFuture = _loadMetrics(signedIn);
            }
            final name = (userProvider.UserName ?? '').trim();
            final email = (userProvider.UserEmail ?? '').trim();
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 112),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF262626), width: 8),
                      ),
                      child: Icon(
                        signedIn ? Icons.person : Icons.sentiment_satisfied_alt,
                        color: Colors.white70,
                        size: 38,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: GestureDetector(
                        onTap: signedIn
                            ? () => _open(const AccountScreen())
                            : () => _open(const LoginScreen()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              signedIn
                                  ? (name.isEmpty ? 'حسابي' : name)
                                  : 'تسجيل الدخول',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: PhoneUi.title(context, color: Colors.white)
                                  .copyWith(
                                fontSize: 28,
                              ),
                            ),
                            if (email.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 5),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: PhoneUi.meta(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          signedIn ? () => _open(const AccountScreen()) : null,
                      icon: const Icon(Icons.hexagon_outlined,
                          color: Colors.white, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                RoundedFeedPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.auto_stories_outlined,
                              color: PhoneUiColors.blue),
                          const SizedBox(width: 8),
                          Text('حساب القراءة',
                              style: PhoneUi.body(context).copyWith(
                                fontSize: 18,
                                color: const Color(0xFF8BA02F),
                                fontWeight: FontWeight.w700,
                              )),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: PhoneUi.fantasyGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              signedIn ? 'نشط' : 'زائر',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),
                      FutureBuilder<_ProfileMetrics>(
                        future: _metricsFuture,
                        builder: (context, snapshot) {
                          final metrics =
                              snapshot.data ?? const _ProfileMetrics.empty();
                          final loading = snapshot.connectionState ==
                              ConnectionState.waiting;
                          final failed = snapshot.hasError;
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  _ProfileMetric(
                                    label: 'المكتبة',
                                    value: loading
                                        ? '...'
                                        : metrics.libraryCount.toString(),
                                  ),
                                  _ProfileMetric(
                                    label: 'القراءة',
                                    value: loading
                                        ? '...'
                                        : metrics.readingCount.toString(),
                                  ),
                                  _ProfileMetric(
                                    label: 'التقييمات',
                                    value: loading
                                        ? '...'
                                        : metrics.reviewCount.toString(),
                                  ),
                                  _ProfileMetric(
                                    label: 'المتابعة',
                                    value: loading
                                        ? '...'
                                        : metrics.followCount.toString(),
                                  ),
                                ],
                              ),
                              if (failed) ...<Widget>[
                                const SizedBox(height: 12),
                                Text(
                                  'تعذر تحميل أرقام الحساب حالياً.',
                                  textAlign: TextAlign.center,
                                  style: PhoneUi.meta(context)
                                      .copyWith(fontSize: 13),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _SmallProfileCard(
                        icon: Icons.bookmark_border,
                        label: 'المحفوظات',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SmallProfileCard(
                        icon: Icons.mail_outline,
                        label: 'الدعم',
                        onTap: _supportEmail,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: signedIn
                      ? () => _open(const UploadDataScreen())
                      : () => _open(const LoginScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: PhoneUi.fantasyGradient,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.draw_outlined, size: 34),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'كن كاتباً',
                            style: PhoneUi.sectionTitle(context),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 32),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                RoundedFeedPanel(
                  child: Column(
                    children: <Widget>[
                      _MenuItem(
                        icon: Icons.inbox_outlined,
                        label: 'الإشعارات',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.person_outline,
                        label: 'معلومات الحساب',
                        onTap: signedIn
                            ? () => _open(const AccountScreen())
                            : () => _open(const LoginScreen()),
                      ),
                      _MenuItem(
                        icon: Icons.library_books_outlined,
                        label: 'مكتبتي',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.help_outline,
                        label: 'الأسئلة الشائعة',
                        onTap: () => _open(const FaqScreen()),
                      ),
                    ],
                  ),
                ),
                RoundedFeedPanel(
                  child: Column(
                    children: <Widget>[
                      _MenuItem(
                        icon: Icons.dark_mode_outlined,
                        label: 'الوضع الداكن',
                        trailing: Switch(
                          value: _darkMode,
                          onChanged: (value) =>
                              setState(() => _darkMode = value),
                        ),
                        onTap: () => setState(() => _darkMode = !_darkMode),
                      ),
                      _MenuItem(
                        icon: Icons.favorite_border,
                        label: 'قيّم NOVELFLEX',
                        subtitle: 'رأيك يساعدنا نحسن تجربة القراءة.',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.headset_mic_outlined,
                        label: 'تواصل مع الدعم',
                        onTap: _supportEmail,
                      ),
                      if (signedIn)
                        _MenuItem(
                          icon: Icons.logout,
                          label: _loggingOut
                              ? 'جاري تسجيل الخروج...'
                              : 'تسجيل الخروج',
                          onTap:
                              _loggingOut ? null : () => _logout(userProvider),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label, style: PhoneUi.meta(context)),
        const SizedBox(height: 10),
        Text(
          value,
          style: PhoneUi.meta(context).copyWith(
            color: const Color(0xFFC5C5C5),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ProfileMetrics {
  const _ProfileMetrics({
    required this.libraryCount,
    required this.readingCount,
    required this.reviewCount,
    required this.followCount,
  });

  const _ProfileMetrics.empty()
      : libraryCount = 0,
        readingCount = 0,
        reviewCount = 0,
        followCount = 0;

  final int libraryCount;
  final int readingCount;
  final int reviewCount;
  final int followCount;
}

class _SmallProfileCard extends StatelessWidget {
  const _SmallProfileCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: PhoneUiColors.lavender,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: PhoneUi.body(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 31),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label,
                      style: PhoneUi.body(context).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 5),
                    Text(subtitle!,
                        style: PhoneUi.meta(context).copyWith(fontSize: 15)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
