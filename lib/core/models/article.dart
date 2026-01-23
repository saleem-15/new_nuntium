import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String sourceName;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  bool isSaved;

  @HiveField(6)
  final String content;

  @HiveField(7)
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.sourceName,
    required this.imageUrl,
    this.isSaved = false,
    required this.content,
    required this.url,
  });

  // دوال التحويل (اختيارية إذا كنت ستستخدم Hive فقط، ولكنها مفيدة للـ API)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'isSaved': isSaved,
      'content': content,
      'url': url,
    };
  }

  // تحديث factory Article.fromMap
  factory Article.fromMap(
    Map<String, dynamic> map, {
    String category = 'General',
  }) {
    return Article(
      // بما أن NewsAPI لا تعطي ID، نستخدم الرابط كمفتاح فريد
      id: map['url'] ?? DateTime.now().toIso8601String(),
      title: map['title'] ?? 'No Title',
      category: category,
      sourceName: map['source']['name'],
      imageUrl:
          map['urlToImage'] ?? 'https://placehold.co/600x400', // صورة افتراضية
      content: map['content'] ?? map['description'] ?? '',
      url: map['url'],
    );
  }
}
