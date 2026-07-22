import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:nuntium/features/categories/domain/entities/category_entity.dart';
import 'package:nuntium/features/categories/domain/use_case/get_cateogories_use_case.dart';
import 'package:nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';
import 'package:nuntium/features/home/domain/use_cases/search_news_use_case.dart';
import 'package:nuntium/features/home/presentation/bloc/home_bloc.dart';
import 'package:nuntium/features/home/presentation/bloc/home_event.dart';
import 'package:nuntium/features/home/presentation/bloc/home_state.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([
  FetchNewsUseCase,
  SearchNewsUseCase,
  ToggleBookmarkUseCase,
  GetCategoriesUseCase,
  WatchBookmarksChangesUseCase,
  CheckIfSavedUseCase,
])
void main() {
  late MockFetchNewsUseCase mockFetchNewsUseCase;
  late MockSearchNewsUseCase mockSearchNewsUseCase;
  late MockToggleBookmarkUseCase mockToggleBookmarkUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockWatchBookmarksChangesUseCase mockWatchBookmarksChangesUseCase;
  late MockCheckIfSavedUseCase mockCheckIfSavedUseCase;

  const tCategories = [
    CategoryEntity(id: 'sports', name: 'Sports', iconPath: 'sports_icon'),
    CategoryEntity(id: 'tech', name: 'Technology', iconPath: 'tech_icon'),
  ];

  final tArticles = [
    Article(
      id: '1',
      title: 'Test Article 1',
      category: 'sports',
      sourceName: 'BBC',
      imageUrl: 'http://example.com/1.jpg',
      content: 'Content 1',
      url: 'http://example.com/1',
      isSaved: false,
    ),
    Article(
      id: '2',
      title: 'Test Article 2',
      category: 'sports',
      sourceName: 'CNN',
      imageUrl: 'http://example.com/2.jpg',
      content: 'Content 2',
      url: 'http://example.com/2',
      isSaved: false,
    ),
  ];

  HomeBloc buildBloc() => HomeBloc(
    fetchNewsUseCase: mockFetchNewsUseCase,
    searchNewsUseCase: mockSearchNewsUseCase,
    toggleBookmarkUseCase: mockToggleBookmarkUseCase,
    getCategoriesUseCase: mockGetCategoriesUseCase,
    watchBookmarksChangesUseCase: mockWatchBookmarksChangesUseCase,
    checkIfSavedUseCase: mockCheckIfSavedUseCase,
  );

  setUp(() {
    mockFetchNewsUseCase = MockFetchNewsUseCase();
    mockSearchNewsUseCase = MockSearchNewsUseCase();
    mockToggleBookmarkUseCase = MockToggleBookmarkUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockWatchBookmarksChangesUseCase = MockWatchBookmarksChangesUseCase();
    mockCheckIfSavedUseCase = MockCheckIfSavedUseCase();

    // Default stubbing for streams and synchronous methods
    when(
      mockWatchBookmarksChangesUseCase.call(),
    ).thenAnswer((_) => Stream<BookmarkChangeEvent>.empty());
    when(mockCheckIfSavedUseCase.call(any)).thenReturn(false);
  });

  group('HomeStarted Event', () {
    blocTest<HomeBloc, HomeState>(
      'Emits [loading, loading with categories, loaded] when HomeStarted succeeds (Happy Path)',
      setUp: () {
        when(
          mockGetCategoriesUseCase.call(isForHome: true),
        ).thenAnswer((_) async => const Right(tCategories));

        when(
          mockFetchNewsUseCase.call(
            category: tCategories.first.id,
            page: 1,
            pageSize: 40,
          ),
        ).thenAnswer((_) async => Right(tArticles));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(HomeStarted()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        HomeState(
          status: HomeStatus.loading,
          categories: tCategories,
          selectedCategory: tCategories.first,
        ),
        HomeState(
          status: HomeStatus.loaded,
          categories: tCategories,
          selectedCategory: tCategories.first,
          articles: tArticles,
          currentPage: 1,
          hasNextPage: false,
        ),
      ],
      verify: (_) {
        verify(mockWatchBookmarksChangesUseCase.call()).called(1);
        verify(mockGetCategoriesUseCase.call(isForHome: true)).called(1);
        verify(
          mockFetchNewsUseCase.call(
            category: tCategories.first.id,
            page: 1,
            pageSize: 40,
          ),
        ).called(1);
        verify(mockCheckIfSavedUseCase.call('1')).called(1);
        verify(mockCheckIfSavedUseCase.call('2')).called(1);
      },
    );
  });

  group('HomeCategoryChanged Event', () {
    final tTechArticles = [
      Article(
        id: '3',
        title: 'Tech Article 1',
        category: 'tech',
        sourceName: 'TechCrunch',
        imageUrl: 'http://example.com/3.jpg',
        content: 'Tech Content 1',
        url: 'http://example.com/3',
        isSaved: false,
      ),
    ];

    blocTest<HomeBloc, HomeState>(
      'Emits [loading with cleared articles & resets page/searchQuery, loaded] when HomeCategoryChanged succeeds',
      setUp: () {
        when(
          mockFetchNewsUseCase.call(
            category: tCategories[1].id,
            page: 1,
            pageSize: 40,
          ),
        ).thenAnswer((_) async => Right(tTechArticles));
      },
      seed: () => HomeState(
        status: HomeStatus.loaded,
        categories: tCategories,
        selectedCategory: tCategories.first,
        articles: tArticles,
        searchQuery: 'old search',
        currentPage: 3,
        hasNextPage: false,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(HomeCategoryChanged(category: tCategories[1])),
      expect: () => [
        HomeState(
          status: HomeStatus.loading,
          categories: tCategories,
          selectedCategory: tCategories[1],
          articles: const [],
          searchQuery: '',
          currentPage: 1,
          hasNextPage: true,
        ),
        HomeState(
          status: HomeStatus.loaded,
          categories: tCategories,
          selectedCategory: tCategories[1],
          articles: tTechArticles,
          searchQuery: '',
          currentPage: 1,
          hasNextPage: false,
        ),
      ],
      verify: (_) {
        verify(
          mockFetchNewsUseCase.call(
            category: tCategories[1].id,
            page: 1,
            pageSize: 40,
          ),
        ).called(1);
        
        final articleId = tTechArticles.first.id;
        verify(mockCheckIfSavedUseCase.call(articleId)).called(1);
        verifyNever(
          mockSearchNewsUseCase.call(
            query: anyNamed('query'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      },
    );
  });

  group('HomeSearchSubmitted Event', () {
    final tSearchResults = [
      Article(
        id: '10',
        title: 'Flutter News',
        category: 'general',
        sourceName: 'Medium',
        imageUrl: 'http://example.com/10.jpg',
        content: 'Flutter Content',
        url: 'http://example.com/10',
        isSaved: false,
      ),
    ];

    blocTest<HomeBloc, HomeState>(
      'Emits [loading with searchQuery & empty articles, loaded] when search succeeds',
      setUp: () {
        when(
          mockSearchNewsUseCase.call(
            query: 'Flutter',
            page: 1,
            pageSize: 40,
          ),
        ).thenAnswer((_) async => Right(tSearchResults));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(HomeSearchSubmitted(query: 'Flutter')),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        const HomeState(
          status: HomeStatus.loading,
          searchQuery: 'Flutter',
          currentPage: 1,
          hasNextPage: true,
          articles: [],
        ),
        HomeState(
          status: HomeStatus.loaded,
          searchQuery: 'Flutter',
          currentPage: 1,
          hasNextPage: false,
          articles: tSearchResults,
        ),
      ],
      verify: (_) {
        verify(
          mockSearchNewsUseCase.call(
            query: 'Flutter',
            page: 1,
            pageSize: 40,
          ),
        ).called(1);
        verifyNever(
          mockFetchNewsUseCase.call(
            category: anyNamed('category'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      },
    );

    blocTest<HomeBloc, HomeState>(
      'Debounces rapid search events and executes search for only the final query',
      setUp: () {
        when(
          mockSearchNewsUseCase.call(
            query: 'Flutter',
            page: 1,
            pageSize: 40,
          ),
        ).thenAnswer((_) async => Right(tSearchResults));
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(HomeSearchSubmitted(query: 'F'));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(HomeSearchSubmitted(query: 'Flu'));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(HomeSearchSubmitted(query: 'Flutter'));
      },
      wait: const Duration(milliseconds: 350),
      expect: () => [
        const HomeState(
          status: HomeStatus.loading,
          searchQuery: 'Flutter',
          currentPage: 1,
          hasNextPage: true,
          articles: [],
        ),
        HomeState(
          status: HomeStatus.loaded,
          searchQuery: 'Flutter',
          currentPage: 1,
          hasNextPage: false,
          articles: tSearchResults,
        ),
      ],
      verify: (_) {
        verify(
          mockSearchNewsUseCase.call(
            query: 'Flutter',
            page: 1,
            pageSize: 40,
          ),
        ).called(1);
        verifyNever(
          mockSearchNewsUseCase.call(
            query: 'F',
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
        verifyNever(
          mockSearchNewsUseCase.call(
            query: 'Flu',
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      },
    );
  });

  group('HomeNextPageRequested Event', () {
    final tPage2Articles = [
      Article(
        id: '3',
        title: 'Test Article 3',
        category: 'sports',
        sourceName: 'ESPN',
        imageUrl: 'http://example.com/3.jpg',
        content: 'Content 3',
        url: 'http://example.com/3',
        isSaved: false,
      ),
    ];

    blocTest<HomeBloc, HomeState>(
      'Emits [loadingNextPage, loaded with appended articles & page 2] when hasNextPage is true',
      setUp: () {
        when(
          mockFetchNewsUseCase.call(
            category: tCategories.first.id,
            page: 2,
            pageSize: 40,
          ),
        ).thenAnswer((_) async => Right(tPage2Articles));
      },
      seed: () => HomeState(
        status: HomeStatus.loaded,
        categories: tCategories,
        selectedCategory: tCategories.first,
        articles: tArticles,
        currentPage: 1,
        hasNextPage: true,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(HomeNextPageRequested()),
      expect: () => [
        HomeState(
          status: HomeStatus.loadingNextPage,
          categories: tCategories,
          selectedCategory: tCategories.first,
          articles: tArticles,
          currentPage: 1,
          hasNextPage: true,
        ),
        HomeState(
          status: HomeStatus.loaded,
          categories: tCategories,
          selectedCategory: tCategories.first,
          articles: [...tArticles, ...tPage2Articles],
          currentPage: 2,
          hasNextPage: false,
        ),
      ],
      verify: (_) {
        verify(
          mockFetchNewsUseCase.call(
            category: tCategories.first.id,
            page: 2,
            pageSize: 40,
          ),
        ).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'Emits nothing when hasNextPage is false (Guard Clause)',
      seed: () => HomeState(
        status: HomeStatus.loaded,
        categories: tCategories,
        selectedCategory: tCategories.first,
        articles: tArticles,
        currentPage: 1,
        hasNextPage: false,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(HomeNextPageRequested()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockFetchNewsUseCase.call(
            category: anyNamed('category'),
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      },
    );
  });

  group('HomeBookmarkToggled Event', () {
    final targetArticle = tArticles.first;

    blocTest<HomeBloc, HomeState>(
      'Emits [optimisticState] with toggled isSaved when toggle succeeds',
      setUp: () {
        when(
          mockToggleBookmarkUseCase.call(article: targetArticle),
        ).thenAnswer((_) async => true);
      },
      seed: () => HomeState(
        status: HomeStatus.loaded,
        articles: tArticles,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(HomeBookmarkToggled(article: targetArticle)),
      expect: () => [
        HomeState(
          status: HomeStatus.loaded,
          articles: [
            targetArticle.copyWith(isSaved: true),
            tArticles[1],
          ],
        ),
      ],
      verify: (_) {
        verify(mockToggleBookmarkUseCase.call(article: targetArticle)).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'Emits [optimisticState, restoredState] (Rollback) when toggle returns false',
      setUp: () {
        when(
          mockToggleBookmarkUseCase.call(article: targetArticle),
        ).thenAnswer((_) async => false);
      },
      seed: () => HomeState(
        status: HomeStatus.loaded,
        articles: tArticles,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(HomeBookmarkToggled(article: targetArticle)),
      expect: () => [
        HomeState(
          status: HomeStatus.loaded,
          articles: [
            targetArticle.copyWith(isSaved: true),
            tArticles[1],
          ],
        ),
        HomeState(
          status: HomeStatus.loaded,
          articles: tArticles,
        ),
      ],
      verify: (_) {
        verify(mockToggleBookmarkUseCase.call(article: targetArticle)).called(1);
      },
    );
  });

  group('HomeBookmarkSyncRequested Event', () {
    blocTest<HomeBloc, HomeState>(
      'Emits state with updated isSaved for matching article ID',
      seed: () => HomeState(
        status: HomeStatus.loaded,
        articles: tArticles,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(
        HomeBookmarkSyncRequested(
          articleId: tArticles.first.id,
          isSaved: true,
        ),
      ),
      expect: () => [
        HomeState(
          status: HomeStatus.loaded,
          articles: [
            tArticles.first.copyWith(isSaved: true),
            tArticles[1],
          ],
        ),
      ],
    );
  });
}
