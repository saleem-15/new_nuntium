import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/get_saved_articles_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_state.dart';

import 'bookmarks_cubit_test.mocks.dart';

@GenerateMocks([
  GetSavedArticlesUseCase,
  DeleteBookmarkUseCase,
  WatchBookmarksChangesUseCase,
])
void main() {
  late MockGetSavedArticlesUseCase mockGetSavedArticlesUseCase;
  late MockDeleteBookmarkUseCase mockDeleteBookmarkUseCase;
  late MockWatchBookmarksChangesUseCase mockWatchBookmarksChangesUseCase;

  blocTest<BookmarksCubit, BookmarksState>(
    'Emits [BookmarksLoading, BookmarksLoaded] when initialized',
    setUp: () {
      mockGetSavedArticlesUseCase = MockGetSavedArticlesUseCase();
      mockDeleteBookmarkUseCase = MockDeleteBookmarkUseCase();
      mockWatchBookmarksChangesUseCase = MockWatchBookmarksChangesUseCase();

      when(mockGetSavedArticlesUseCase.call()).thenReturn(savedArticles);

      when(
        mockWatchBookmarksChangesUseCase.call(),
      ).thenAnswer((_) => Stream<BookmarkChangeEvent>.empty());
    },
    build: () => BookmarksCubit(
      getSavedArticlesUseCase: mockGetSavedArticlesUseCase,
      deleteBookmarkUseCase: mockDeleteBookmarkUseCase,
      watchBookmarksChangesUseCase: mockWatchBookmarksChangesUseCase,
    ),
    expect: () => [const BookmarksLoading(), BookmarksLoaded(savedArticles)],
    verify: (_) {
      verify(mockGetSavedArticlesUseCase.call()).called(1);
      verify(mockWatchBookmarksChangesUseCase.call()).called(1);
    },
  );
}

final List<Article> savedArticles = [];
