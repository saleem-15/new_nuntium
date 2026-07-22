import 'package:equatable/equatable.dart';
import 'package:nuntium/core/entities/article.dart';

enum BookmarkAction { added, removed }

/// A wrapper class to describe what happened in the bookmarks
class BookmarkChangeEvent extends Equatable {
  final BookmarkAction action;
  final Article article;

  const BookmarkChangeEvent({required this.action, required this.article});

  @override
  List<Object?> get props => [action, article];
}
