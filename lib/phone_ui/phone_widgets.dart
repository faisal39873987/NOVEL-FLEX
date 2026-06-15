import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'phone_design.dart';
import 'phone_models.dart';

class PhoneShellHeader extends StatelessWidget {
  const PhoneShellHeader({
    super.key,
    this.activeTab = 'روايات',
    this.tabs = const <String>['روايات', 'جديد', 'تصنيفات', 'فان فيك'],
    this.onSearchTap,
  });

  final String activeTab;
  final List<String> tabs;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PhoneUiColors.black,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: PhoneUi.searchGradient,
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: GestureDetector(
                    onTap: onSearchTap,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.search, color: Colors.white, size: 23),
                            SizedBox(width: 8),
                            Text(
                              'ابحث عن رواية',
                              style: TextStyle(
                                color: Color(0xFF8F8F8F),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 3,
                          decoration: const BoxDecoration(
                            gradient: PhoneUi.searchGradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                const Icon(Icons.language, color: Colors.white, size: 34),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabs.map((String tab) {
                final isActive = tab == activeTab;
                return Text(
                  tab,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF777777),
                    fontSize: 20,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: 0,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedFeedPanel extends StatelessWidget {
  const RoundedFeedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: PhoneUiColors.white,
        borderRadius: BorderRadius.circular(PhoneUi.panelRadius),
      ),
      child: child,
    );
  }
}

class PhoneTagPill extends StatelessWidget {
  const PhoneTagPill({
    super.key,
    required this.label,
    this.active = false,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: active ? PhoneUiColors.ink : PhoneUiColors.soft,
        borderRadius: BorderRadius.circular(PhoneUi.pillRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : PhoneUiColors.muted,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.width,
    this.height,
    this.radius = 8,
  });

  final PhoneBook book;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cover = book.coverUrl.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: cover.isEmpty
            ? _FallbackCover(book: book)
            : CachedNetworkImage(
                imageUrl: cover,
                fit: BoxFit.cover,
                placeholder: (_, __) => _FallbackCover(book: book),
                errorWidget: (_, __, ___) => _FallbackCover(book: book),
              ),
      ),
    );
  }
}

class _FallbackCover extends StatelessWidget {
  const _FallbackCover({required this.book});

  final PhoneBook book;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF17204D), Color(0xFF3458D4)],
        ),
      ),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.bottomRight,
      child: Text(
        book.category.isEmpty ? 'NOVELFLEX' : book.category,
        maxLines: 2,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class CoverGridItem extends StatelessWidget {
  const CoverGridItem({
    super.key,
    required this.book,
    this.onTap,
  });

  final PhoneBook book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.72,
            child: BookCover(
                book: book, width: double.infinity, height: double.infinity),
          ),
          const SizedBox(height: 9),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PhoneUi.body(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            book.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: PhoneUi.meta(context).copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class RichBookListTile extends StatelessWidget {
  const RichBookListTile({
    super.key,
    required this.book,
    this.onTap,
  });

  final PhoneBook book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookCover(book: book, width: 86, height: 116),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: <Widget>[
                      _MiniTag('#${book.category}'),
                      if (book.status.isNotEmpty) _MiniTag(book.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: PhoneUi.body(context).copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    book.description.isEmpty
                        ? 'رواية متاحة للقراءة على NOVELFLEX.'
                        : book.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: PhoneUi.meta(context).copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${book.category} · ${book.chapterCount} فصل',
                    style: PhoneUi.meta(context),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_horiz, color: PhoneUiColors.muted),
          ],
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: PhoneUiColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class PhoneEmptyState extends StatelessWidget {
  const PhoneEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        children: <Widget>[
          const Icon(Icons.menu_book_outlined, size: 42),
          const SizedBox(height: 12),
          Text(title, style: PhoneUi.sectionTitle(context)),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: PhoneUi.meta(context),
          ),
        ],
      ),
    );
  }
}

class PhoneLoadingPanel extends StatelessWidget {
  const PhoneLoadingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedFeedPanel(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 16),
          Text('جاري تحميل الروايات...', style: PhoneUi.meta(context)),
        ],
      ),
    );
  }
}
