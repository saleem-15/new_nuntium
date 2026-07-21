import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
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

  final savedArticles = [
    Article(
      id: 'id',
      title: 'title',
      category: 'category',
      sourceName: 'sourceName',
      imageUrl: 'imageUrl',
      content: 'content',
      url: 'url',
    ),
    Article(
      id: 'id2',
      title: 'title2',
      category: 'category2',
      sourceName: 'sourceName2',
      imageUrl: 'imageUrl2',
      content: 'content2',
      url: 'url2',
    ),
  ];
  final tArticle = savedArticles.first;

  setUp(() {
    mockGetSavedArticlesUseCase = MockGetSavedArticlesUseCase();
    mockDeleteBookmarkUseCase = MockDeleteBookmarkUseCase();
    mockWatchBookmarksChangesUseCase = MockWatchBookmarksChangesUseCase();
  });

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
    expect: () => [
      const BookmarksLoading(),
      BookmarksLoaded(savedArticles.reversed.toList()),
    ],
    verify: (_) {
      verify(mockGetSavedArticlesUseCase.call()).called(1);
      verify(mockWatchBookmarksChangesUseCase.call()).called(1);
    },
  );

  blocTest<BookmarksCubit, BookmarksState>(
    'Emits [BookmarksLoaded(updatedArticles)] when removeBookmark succeeds (Optimistic Update)',
    setUp: () {
      when(mockDeleteBookmarkUseCase.call(any)).thenAnswer((_) async {});
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

    // Ignore the 2 states emitted by scheduleMicrotask(_init)
    skip: 2,
    act: (cubit) async {
      // Let the constructor's scheduleMicrotask(_init) finish first!
      await Future.microtask(() {});
      return cubit.removeBookmark(tArticle);
    },
    expect: () {
      final updatedArticles = savedArticles.reversed
          .where((e) => e.id != tArticle.id)
          .toList();
      return [BookmarksLoaded(updatedArticles)];
    },
    verify: (_) {
      verify(mockDeleteBookmarkUseCase.call(tArticle)).called(1);
    },
  );

  blocTest<BookmarksCubit, BookmarksState>(
    'Emits [BookmarksLoaded(optimisticUpdatedArticles), BookmarksLoaded(originalArticles), BookmarksError] when removeBookmark fails (RollBack)',
    setUp: () {
      when(mockDeleteBookmarkUseCase.call(any)).thenThrow(Exception());
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

    // Ignore the 2 states emitted by scheduleMicrotask(_init)
    skip: 2,
    act: (cubit) async {
      // Let the constructor's scheduleMicrotask(_init) finish first!
      await Future.microtask(() {});
      return cubit.removeBookmark(tArticle);
    },
    expect: () {
      final optimisticUpdatedArticles = savedArticles.reversed
          .where((e) => e.id != tArticle.id)
          .toList();
      return [
        BookmarksLoaded(optimisticUpdatedArticles),
        BookmarksLoaded(savedArticles.reversed.toList()),
        isA<BookmarksError>(),
      ];
    },
    verify: (_) {
      verify(mockDeleteBookmarkUseCase.call(tArticle)).called(1);
    },
  );
}
