import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/supabase_legacy_api_adapter.dart';
import '../tab_screen.dart';
import 'phone_design.dart';
import 'phone_models.dart';

class PhoneOnboardingPreferencesScreen extends StatefulWidget {
  const PhoneOnboardingPreferencesScreen({
    super.key,
    this.nextScreen = const TabScreen(),
  });

  static const completedKey = 'phone_onboarding_preferences_completed';
  static const selectedIdsKey = 'phone_onboarding_preference_category_ids';
  static const selectedTitlesKey =
      'phone_onboarding_preference_category_titles';

  final Widget nextScreen;

  @override
  State<PhoneOnboardingPreferencesScreen> createState() =>
      _PhoneOnboardingPreferencesScreenState();
}

class _PhoneOnboardingPreferencesScreenState
    extends State<PhoneOnboardingPreferencesScreen> {
  late Future<List<PhoneCategory>> _categoriesFuture = _loadCategories();
  final Set<int> _selectedIds = <int>{};
  bool _saving = false;

  Future<List<PhoneCategory>> _loadCategories() async {
    try {
      final response = await SupabaseLegacyApiAdapter().searchCategories('');
      final rows = response['data'];
      if (rows is List && rows.isNotEmpty) {
        return rows.map(PhoneCategory.fromLegacy).toList();
      }
    } catch (_) {
      // First-run preferences should not block launch if public content is
      // temporarily unavailable.
    }
    return _fallbackCategories;
  }

  Future<void> _continue(List<PhoneCategory> categories) async {
    if (_saving || _selectedIds.isEmpty) return;

    setState(() => _saving = true);
    final selectedTitles = categories
        .where((category) => _selectedIds.contains(category.id))
        .map((category) => category.title)
        .toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PhoneOnboardingPreferencesScreen.completedKey, true);
    await prefs.setStringList(
      PhoneOnboardingPreferencesScreen.selectedIdsKey,
      _selectedIds.map((id) => id.toString()).toList(),
    );
    await prefs.setStringList(
      PhoneOnboardingPreferencesScreen.selectedTitlesKey,
      selectedTitles,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.nextScreen),
    );
  }

  Future<void> _skip() async {
    if (_saving) return;

    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PhoneOnboardingPreferencesScreen.completedKey, true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.nextScreen),
    );
  }

  void _toggle(PhoneCategory category) {
    setState(() {
      if (_selectedIds.contains(category.id)) {
        _selectedIds.remove(category.id);
      } else {
        _selectedIds.add(category.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoneUiColors.black,
      body: SafeArea(
        child: FutureBuilder<List<PhoneCategory>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            final categories = snapshot.data ?? const <PhoneCategory>[];
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: PhoneUi.searchGradient,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'N',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'NOVELFLEX',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _saving ? null : _skip,
                        child: const Text(
                          'تخطي',
                          style: TextStyle(color: Color(0xFF9A9A9A)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 70, 22, 24),
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            height: 1.08,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'اختر تفضيلاتك\n'),
                            TextSpan(
                              text: 'وابدأ القراءة',
                              style: TextStyle(color: Color(0xFF4A4A4A)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const _LoadingPreferenceCard()
                      else
                        ...categories.map(
                          (category) => _PreferenceCard(
                            category: category,
                            selected: _selectedIds.contains(category.id),
                            onTap: () => _toggle(category),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _selectedIds.isEmpty || _saving
                              ? null
                              : () => _continue(categories),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF2A2A2A),
                            foregroundColor: Colors.black,
                            disabledForegroundColor: const Color(0xFF777777),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _saving ? 'جاري الحفظ...' : 'ابدأ القراءة',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'يمكنك تغيير تفضيلاتك لاحقاً من الملف الشخصي.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final PhoneCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 14),
        height: 144,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: selected
              ? PhoneUi.searchGradient
              : const LinearGradient(
                  colors: <Color>[Color(0xFFEAF9FF), Color(0xFFFFE8EC)],
                ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _MiniPill('#روايات'),
                      _MiniPill('#${category.title}'),
                      if (category.count > 0)
                        _MiniPill('${category.count} عمل'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                selected ? Icons.check : Icons.chevron_right,
                color: selected ? Colors.white : Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF777777),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LoadingPreferenceCard extends StatelessWidget {
  const _LoadingPreferenceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

const List<PhoneCategory> _fallbackCategories = <PhoneCategory>[
  PhoneCategory(id: 101, title: 'فانتازيا'),
  PhoneCategory(id: 102, title: 'رومانسي'),
  PhoneCategory(id: 103, title: 'غموض'),
  PhoneCategory(id: 104, title: 'خيال علمي'),
];
