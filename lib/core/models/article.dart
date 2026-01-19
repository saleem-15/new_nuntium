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
  final String imageUrl;

  @HiveField(4)
  final bool isSaved;

  @HiveField(5)
  final String? content;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.isSaved = false,
    this.content,
  });

  // دوال التحويل (اختيارية إذا كنت ستستخدم Hive فقط، ولكنها مفيدة للـ API)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'isSaved': isSaved,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map, String documentId) {
    return Article(
      id: documentId,
      title: map['title'] ?? '',
      category: map['category'] ?? 'General',
      imageUrl: map['imageUrl'] ?? '',
      isSaved: map['isSaved'] ?? false,
      content: map['content'],
    );
  }

  Article copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    bool? isSaved,
    String? content,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaved: isSaved ?? this.isSaved,
      content: content ?? this.content,
    );
  }
}
