class PhoneBook {
  const PhoneBook({
    required this.id,
    required this.title,
    required this.category,
    this.description = '',
    this.coverUrl = '',
    this.chapterCount = 0,
    this.rating = 0,
    this.status = '',
  });

  final int id;
  final String title;
  final String category;
  final String description;
  final String coverUrl;
  final int chapterCount;
  final double rating;
  final String status;

  static PhoneBook fromLegacy(dynamic value) {
    final row = _asMap(value);
    final categories = row['categories'];
    final firstCategory = categories is List && categories.isNotEmpty
        ? _asMap(categories.first)
        : <String, dynamic>{};
    return PhoneBook(
      id: _asInt(row['id']),
      title: _firstText(<dynamic>[
        row['title'],
        row['bookTitle'],
        row['title_ar'],
        row['title_en'],
        'رواية جديدة',
      ]),
      category: _firstText(<dynamic>[
        row['catgoryTitle'],
        firstCategory['title'],
        firstCategory['name_ar'],
        firstCategory['name_en'],
        row['category'],
        'روايات',
      ]),
      description: _firstText(<dynamic>[
        row['description'],
        row['bookDescription'],
        row['description_ar'],
        row['description_en'],
      ]),
      coverUrl: _firstText(<dynamic>[
        row['image_path'],
        row['image'],
        row['cover_url'],
        row['coverImageUrl'],
      ]),
      chapterCount: _asInt(row['chapters_count']),
      rating: _asDouble(row['rating_average']),
      status: _firstText(<dynamic>[row['status']]),
    );
  }
}

class PhoneCategory {
  const PhoneCategory({
    required this.id,
    required this.title,
    this.imageUrl = '',
    this.count = 0,
  });

  final int id;
  final String title;
  final String imageUrl;
  final int count;

  static PhoneCategory fromLegacy(dynamic value) {
    final row = _asMap(value);
    return PhoneCategory(
      id: _asInt(row['category_id'] ?? row['id']),
      title: _firstText(<dynamic>[
        row['titleAr'],
        row['title'],
        row['name_ar'],
        row['name_en'],
        'تصنيف',
      ]),
      imageUrl: _firstText(<dynamic>[row['image_path'], row['image']]),
      count: _asInt(row['count']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return <String, dynamic>{};
}

String _firstText(Iterable<dynamic> values) {
  for (final value in values) {
    if (value == null) {
      continue;
    }
    final text = value.toString().trim();
    if (text.isNotEmpty && text != 'null') {
      return text;
    }
  }
  return '';
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
