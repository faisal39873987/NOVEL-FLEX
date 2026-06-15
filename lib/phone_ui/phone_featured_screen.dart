import 'package:flutter/material.dart';
import 'package:transitioner/transitioner.dart';

import '../MixScreens/BooksScreens/BookDetail.dart';
import '../data/services/supabase_legacy_api_adapter.dart';
import 'phone_design.dart';
import 'phone_models.dart';
import 'phone_widgets.dart';

class PhoneFeaturedScreen extends StatefulWidget {
  const PhoneFeaturedScreen({super.key});

  @override
  State<PhoneFeaturedScreen> createState() => _PhoneFeaturedScreenState();
}

class _PhoneFeaturedScreenState extends State<PhoneFeaturedScreen> {
  late final Future<List<PhoneBook>> _booksFuture = _loadBooks();

  Future<List<PhoneBook>> _loadBooks() async {
    final response = await SupabaseLegacyApiAdapter().homeDetails();
    final data = response['data'];
    final books = <PhoneBook>[];
    if (data is Map) {
      for (final source in <dynamic>[
        data['slider'],
        data['recentlyPublishBooks'],
      ]) {
        if (source is List) {
          books.addAll(source.map(PhoneBook.fromLegacy));
        }
      }
      final categoryBooks = data['categoryBooks'];
      if (categoryBooks is List) {
        for (final category in categoryBooks) {
          if (category is Map && category['books'] is List) {
            books.addAll((category['books'] as List).map(PhoneBook.fromLegacy));
          }
        }
      }
    }

    final unique = <int, PhoneBook>{};
    for (final book in books) {
      if (book.id != 0) {
        unique[book.id] = book;
      }
    }
    return unique.values.toList();
  }

  void _openBook(PhoneBook book) {
    if (book.id == 0) return;
    Transitioner(
      context: context,
      child: BookDetail(bookID: book.id.toString()),
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
      body: FutureBuilder<List<PhoneBook>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          final books = snapshot.data ?? const <PhoneBook>[];
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              const SliverToBoxAdapter(
                  child: PhoneShellHeader(activeTab: 'روايات')),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const PhoneLoadingPanel()
                      else if (snapshot.hasError)
                        const PhoneEmptyState(
                          title: 'تعذر تحميل الصفحة الرئيسية',
                          message:
                              'تحقق من الاتصال وحاول مرة أخرى. إذا استمرت المشكلة سنراجع مصدر البيانات.',
                        )
                      else if (books.isEmpty)
                        const PhoneEmptyState(
                          title: 'لا توجد روايات منشورة بعد',
                          message:
                              'عندما ينشر الكاتب رواية مع فصل جاهز ستظهر هنا تلقائياً.',
                        )
                      else
                        ..._contentSections(books),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _contentSections(List<PhoneBook> books) {
    final featured = _cycle(books, 0, 10);
    final rankings = _cycle(books, 3, 10);
    final weekly = _cycle(books, 2, 8);
    final readers = _cycle(books, 5, 6);
    final cheering = _cycle(books, 8, 8);
    final completed = _cycle(books, 1, 8);
    final serialized = _cycle(books, 4, 8);
    final recommendations = _cycle(books, 0, 8);

    return <Widget>[
      _QuickActionsPanel(),
      _TagPanel(books: featured, onOpen: _openBook),
      _RankingPanel(books: rankings, onOpen: _openBook),
      _CoverGridPanel(
        title: 'مختارات الأسبوع',
        books: weekly,
        columns: 4,
        onOpen: _openBook,
      ),
      _CoverGridPanel(
        title: 'اختيارات القرّاء',
        books: readers,
        columns: 3,
        onOpen: _openBook,
      ),
      _CoverGridPanel(
        title: 'قراءات صاعدة',
        books: cheering,
        columns: 4,
        onOpen: _openBook,
      ),
      _HorizontalBooksPanel(
        title: 'روايات مكتملة',
        books: completed,
        onOpen: _openBook,
      ),
      _CoverGridPanel(
        title: 'روايات متسلسلة',
        books: serialized,
        columns: 4,
        onOpen: _openBook,
      ),
      _DiscussionPanel(),
      _RecommendationPanel(books: recommendations, onOpen: _openBook),
    ];
  }

  List<PhoneBook> _cycle(List<PhoneBook> books, int start, int count) {
    if (books.isEmpty) {
      return const <PhoneBook>[];
    }
    return List<PhoneBook>.generate(
      count.clamp(0, books.length),
      (index) => books[(start + index) % books.length],
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = <_ActionData>[
      const _ActionData(Icons.workspace_premium_outlined, 'مختارات'),
      const _ActionData(Icons.emoji_events_outlined, 'ترتيب'),
      const _ActionData(Icons.flash_on_outlined, 'جديد'),
      const _ActionData(Icons.local_fire_department_outlined, 'شائع'),
      const _ActionData(Icons.card_giftcard_outlined, 'مجاني'),
    ];
    return RoundedFeedPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((item) {
          return Column(
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, color: Colors.black, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: PhoneUi.body(context).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ActionData {
  const _ActionData(this.icon, this.label);

  final IconData icon;
  final String label;

  Color get color {
    switch (label) {
      case 'مختارات':
        return const Color(0xFFFFF4C8);
      case 'ترتيب':
        return const Color(0xFFFFF0D8);
      case 'جديد':
        return const Color(0xFFE8FAFF);
      case 'شائع':
        return const Color(0xFFFFF4E5);
      default:
        return const Color(0xFFFFE7EC);
    }
  }
}

class _TagPanel extends StatelessWidget {
  const _TagPanel({required this.books, required this.onOpen});

  final List<PhoneBook> books;
  final ValueChanged<PhoneBook> onOpen;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Wrap(
            spacing: 14,
            runSpacing: 10,
            children: <Widget>[
              PhoneTagPill(label: '#فانتازيا', active: true),
              PhoneTagPill(label: '#رومانسي'),
              PhoneTagPill(label: '#غموض'),
            ],
          ),
          const SizedBox(height: 22),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: books.take(8).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.25,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () => onOpen(book),
                child: Row(
                  children: <Widget>[
                    BookCover(book: book, width: 54, height: 74),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: PhoneUi.body(context).copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(book.category, style: PhoneUi.meta(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Text('المزيد من الروايات', style: PhoneUi.meta(context)),
              const Spacer(),
              const Icon(Icons.chevron_right, color: PhoneUiColors.muted),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankingPanel extends StatelessWidget {
  const _RankingPanel({required this.books, required this.onOpen});

  final List<PhoneBook> books;
  final ValueChanged<PhoneBook> onOpen;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('الترتيب', style: PhoneUi.sectionTitle(context)),
              const Spacer(),
              Text('المزيد',
                  style: PhoneUi.meta(context).copyWith(fontSize: 18)),
              const Icon(Icons.chevron_right, color: PhoneUiColors.muted),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Text('الأكثر قراءة',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('الأعلى تقييماً',
                        style: PhoneUi.meta(context).copyWith(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: books.take(10).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              mainAxisSpacing: 14,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () => onOpen(book),
                child: Row(
                  children: <Widget>[
                    _RankBadge(rank: index + 1),
                    const SizedBox(width: 8),
                    BookCover(book: book, width: 50, height: 68),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: PhoneUi.body(context).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              )),
                          Text(book.category, style: PhoneUi.meta(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: rank <= 3 ? PhoneUiColors.cyan : const Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '$rank',
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    );
  }
}

class _CoverGridPanel extends StatelessWidget {
  const _CoverGridPanel({
    required this.title,
    required this.books,
    required this.columns,
    required this.onOpen,
  });

  final String title;
  final List<PhoneBook> books;
  final int columns;
  final ValueChanged<PhoneBook> onOpen;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: PhoneUi.sectionTitle(context)),
          const SizedBox(height: 20),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: books.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: columns == 3 ? 0.55 : 0.48,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) => CoverGridItem(
              book: books[index],
              onTap: () => onOpen(books[index]),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('تبديل',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _HorizontalBooksPanel extends StatelessWidget {
  const _HorizontalBooksPanel({
    required this.title,
    required this.books,
    required this.onOpen,
  });

  final String title;
  final List<PhoneBook> books;
  final ValueChanged<PhoneBook> onOpen;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: PhoneUi.sectionTitle(context)),
          const SizedBox(height: 18),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final book = books[index];
                return SizedBox(
                  width: 96,
                  child: CoverGridItem(book: book, onTap: () => onOpen(book)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscussionPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: PhoneUi.discussionGradient,
        borderRadius: BorderRadius.circular(PhoneUi.panelRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('نقرأ معاً', style: PhoneUi.sectionTitle(context)),
              const Spacer(),
              Text('المزيد',
                  style: PhoneUi.meta(context).copyWith(fontSize: 18)),
              const Icon(Icons.chevron_right, color: PhoneUiColors.muted),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'مساحة خفيفة لأسئلة القرّاء واقتراحات القراءة.',
            style: PhoneUi.meta(context).copyWith(fontSize: 17),
          ),
          const SizedBox(height: 18),
          _PromptRow(label: 'سؤال', text: 'ما الرواية التي فاجأتك بجودتها؟'),
          const Divider(height: 28),
          _PromptRow(label: 'نقاش', text: 'ما التصنيف الذي تريد رؤيته أكثر؟'),
          const Divider(height: 28),
          _PromptRow(
              label: 'موضوع', text: 'أفضل بداية فصل قرأتها هذا الأسبوع؟'),
        ],
      ),
    );
  }
}

class _PromptRow extends StatelessWidget {
  const _PromptRow({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: PhoneUi.body(context).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
    );
  }
}

class _RecommendationPanel extends StatelessWidget {
  const _RecommendationPanel({required this.books, required this.onOpen});

  final List<PhoneBook> books;
  final ValueChanged<PhoneBook> onOpen;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('قد يعجبك أيضاً', style: PhoneUi.sectionTitle(context)),
          const SizedBox(height: 18),
          ...books.map((book) => RichBookListTile(
                book: book,
                onTap: () => onOpen(book),
              )),
        ],
      ),
    );
  }
}
