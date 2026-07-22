import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../entities/article.dart';

part 'article_hive_model.g.dart';

@HiveType(typeId: 0)
class ArticleHiveModel extends Equatable {
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

  @HiveField(6)
  final String content;

  @HiveField(7)
  final String url;

  const ArticleHiveModel({
    required this.id,
    required this.title,
    required this.category,
    required this.sourceName,
    required this.imageUrl,
    required this.content,
    required this.url,
  });

  factory ArticleHiveModel.fromEntity(Article article) {
    return ArticleHiveModel(
      id: article.id,
      title: article.title,
      category: article.category,
      sourceName: article.sourceName,
      imageUrl: article.imageUrl,
      content: article.content,
      url: article.url,
    );
  }
  Article toEntity() {
    return Article(
      id: id,
      title: title,
      category: category,
      sourceName: sourceName,
      imageUrl: imageUrl,
      content: content,
      url: url,
      // If an article is stored in the bookmarks Hive box,
      // then by definition it is saved
      isSaved: true,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    sourceName,
    imageUrl,
    content,
    url,
  ];
}
