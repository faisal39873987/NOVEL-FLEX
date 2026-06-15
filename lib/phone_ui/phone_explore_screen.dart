import 'package:flutter/material.dart';
import 'package:transitioner/transitioner.dart';

import '../MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart';
import '../data/services/supabase_legacy_api_adapter.dart';
import 'phone_design.dart';
import 'phone_models.dart';
import 'phone_widgets.dart';

class PhoneExploreScreen extends StatefulWidget {
  const PhoneExploreScreen({super.key});

  @override
  State<PhoneExploreScreen> createState() => _PhoneExploreScreenState();
}

class _PhoneExploreScreenState extends State<PhoneExploreScreen> {
  late final Future<List<PhoneCategory>> _categoriesFuture = _loadCategories();

  Future<List<PhoneCategory>> _loadCategories() async {
    final response = await SupabaseLegacyApiAdapter().searchCategories('');
    final rows = response['data'];
    if (rows is! List) {
      return const <PhoneCategory>[];
    }
    return rows.map(PhoneCategory.fromLegacy).toList();
  }

  void _openCategory(PhoneCategory category) {
    if (category.id == 0) return;
    Transitioner(
      context: context,
      child: GeneralCategoriesScreen(categories_id: category.id.toString()),
      animation: AnimationType.slideLeft,
      duration: const Duration(milliseconds: 420),
      replacement: false,
      curveType: CurveType.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoneUiColors.black,
      body: Column(
        children: <Widget>[
          const PhoneShellHeader(
            activeTab: 'تصنيفات',
            tabs: <String>['روايات', 'كوميكس', 'فان فيك', 'كتب'],
          ),
          Expanded(
            child: FutureBuilder<List<PhoneCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? const <PhoneCategory>[];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _ExploreRail(),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(34),
                            topRight: Radius.circular(34),
                          ),
                        ),
                        child: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : snapshot.hasError
                                ? const _ExploreMessage(
                                    title: 'تعذر تحميل التصنيفات',
                                    message:
                                        'تحقق من الاتصال وحاول مرة أخرى. التصنيفات تأتي من بيانات NOVELFLEX النشطة.',
                                  )
                                : categories.isEmpty
                                    ? const _ExploreMessage(
                                        title: 'لا توجد تصنيفات متاحة حالياً',
                                        message:
                                            'ستظهر التصنيفات هنا بعد تفعيلها في المنصة.',
                                      )
                                    : _GenreGrid(
                                        categories: categories,
                                        onOpen: _openCategory,
                                      ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreMessage extends StatelessWidget {
  const _ExploreMessage({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.category_outlined, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: PhoneUi.sectionTitle(context).copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PhoneUi.meta(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreRail extends StatelessWidget {
  const _ExploreRail();

  @override
  Widget build(BuildContext context) {
    final items = <_RailItem>[
      const _RailItem(Icons.grid_view_rounded, 'تصنيفات', true),
      const _RailItem(Icons.leaderboard_outlined, 'ترتيب', false),
      const _RailItem(Icons.fiber_new_outlined, 'جديد', false),
      const _RailItem(Icons.local_fire_department_outlined, 'شائع', false),
      const _RailItem(Icons.bookmark_border, 'مكتمل', false),
    ];

    return SizedBox(
      width: 96,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 110),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: item.active
                      ? const Color(0xFF2A2A2A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  item.icon,
                  color: item.active ? Colors.white : const Color(0xFF555555),
                  size: 30,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: item.active ? Colors.white : const Color(0xFF777777),
                  fontSize: 13,
                  fontWeight: item.active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RailItem {
  const _RailItem(this.icon, this.label, this.active);

  final IconData icon;
  final String label;
  final bool active;
}

class _GenreGrid extends StatelessWidget {
  const _GenreGrid({
    required this.categories,
    required this.onOpen,
  });

  final List<PhoneCategory> categories;
  final ValueChanged<PhoneCategory> onOpen;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: <Widget>[
                const Icon(Icons.tag, size: 35),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اكتشف الروايات حسب التصنيف',
                    style: PhoneUi.sectionTitle(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => onOpen(category),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: PhoneUiColors.soft,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE7E7E7)),
                    ),
                    child: Row(
                      children: <Widget>[
                        _CategoryStack(category: category),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            category.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: PhoneUi.body(context).copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryStack extends StatelessWidget {
  const _CategoryStack({required this.category});

  final PhoneCategory category;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Transform.rotate(
          angle: -0.12,
          child: _MiniCover(category: category, opacity: 0.65),
        ),
        Positioned(
          left: 11,
          child: Transform.rotate(
            angle: 0.09,
            child: _MiniCover(category: category),
          ),
        ),
      ],
    );
  }
}

class _MiniCover extends StatelessWidget {
  const _MiniCover({required this.category, this.opacity = 1});

  final PhoneCategory category;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 44,
        height: 58,
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: PhoneUi.fantasyGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          category.title.characters.take(2).toString(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
