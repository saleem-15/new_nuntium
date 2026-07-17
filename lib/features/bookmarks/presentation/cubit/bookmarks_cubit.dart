import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/get_saved_articles_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final DeleteBookmarkUseCase _deleteBookmarkUseCase;
  final WatchBookmarksChangesUseCase _watchBookmarksChangesUseCase;
  StreamSubscription? _bookmarksSubscription;

  BookmarksCubit({
    required GetSavedArticlesUseCase getSavedArticlesUseCase,
    required DeleteBookmarkUseCase deleteBookmarkUseCase,
    required WatchBookmarksChangesUseCase watchBookmarksChangesUseCase,
  }) : _getSavedArticlesUseCase = getSavedArticlesUseCase,
       _deleteBookmarkUseCase = deleteBookmarkUseCase,
       _watchBookmarksChangesUseCase = watchBookmarksChangesUseCase,
       super(const BookmarksInitial()) {
    // Defer initialization to the next microtask queue.
    // This allows UI/test listeners to subscribe before initial state transitions are emitted.
    scheduleMicrotask(_init);
  }

  void _init() {
    getSavedArticles(isInitial: true);

    // Watch for global bookmark changes and update the list accordingly
    _bookmarksSubscription = _watchBookmarksChangesUseCase.call().listen(
      (_) => getSavedArticles(isInitial: false),
    );
  }

  void getSavedArticles({bool isInitial = false}) {
    if (isInitial || state is BookmarksInitial) {
      emit(const BookmarksLoading());
    }
    try {
      final savedArticles = _getSavedArticlesUseCase.call();
      emit(BookmarksLoaded(List.unmodifiable(savedArticles.reversed)));
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }

  Future<void> removeBookmark(Article article) async {
    try {
      // Optimistic update to keep UI responsive and prevent any jumpy behaviors
      if (state is BookmarksLoaded) {
        final currentArticles = (state as BookmarksLoaded).articles;
        final updatedArticles = currentArticles
            .where((a) => a.id != article.id)
            .toList();
        emit(BookmarksLoaded(List.unmodifiable(updatedArticles)));
      }

      await _deleteBookmarkUseCase.call(article);
    } catch (e) {
      // Rollback on failure by reloading from local storage
      getSavedArticles(isInitial: false);
      emit(BookmarksError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _bookmarksSubscription?.cancel();
    return super.close();
  }
}
