import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/core/utils/app_logger.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';

import '../../../categories/domain/use_case/get_cateogories_use_case.dart';
import '../../domain/use_cases/fetch_news_use_case.dart';
import '../../domain/use_cases/search_news_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // ---Dependencies---
  final FetchNewsUseCase _fetchNewsUseCase;
  final SearchNewsUseCase _searchNewsUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final WatchBookmarksChangesUseCase _watchBookmarksChangesUseCase;
  final CheckIfSavedUseCase _checkIfSavedUseCase;

  StreamSubscription? _bookmarksSubscription;

  static const int _pageSize = 40;

  /// Tracks article IDs currently being toggled by _onBookmarkToggled.
  /// Used to prevent:
  ///  1. Double-taps from dispatching concurrent toggles for the same article.
  ///  2. Race conditions where a late stream sync event from
  ///     BookmarkRepositoryImpl overrides an in-progress optimistic rollback.
  final _inFlightToggles = <String>{};

  HomeBloc({
    required FetchNewsUseCase fetchNewsUseCase,
    required SearchNewsUseCase searchNewsUseCase,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required WatchBookmarksChangesUseCase watchBookmarksChangesUseCase,
    required CheckIfSavedUseCase checkIfSavedUseCase,
  }) : _fetchNewsUseCase = fetchNewsUseCase,
       _searchNewsUseCase = searchNewsUseCase,
       _toggleBookmarkUseCase = toggleBookmarkUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _watchBookmarksChangesUseCase = watchBookmarksChangesUseCase,
       _checkIfSavedUseCase = checkIfSavedUseCase,
       super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<HomeCategoryChanged>(_onCategoryChanged);
    on<HomeSearchSubmitted>(
      _onSearchChanged,
      transformer: _debounceRestartable(const Duration(milliseconds: 300)),
    );
    on<HomeBookmarkToggled>(_onBookmarkToggled);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeBookmarkSyncRequested>(_onBookmarksSyncRequested);

    // Initial reactive listener setup
    _bookmarksSubscription = _watchBookmarksChangesUseCase.call().listen((
      event,
    ) {
      add(
        HomeBookmarkSyncRequested(
          articleId: event.article.id,
          isSaved: event.action == BookmarkAction.added,
        ),
      );
    });
  }

  /// Reactive Listener: Automatically sync saved status across the whole app.
  /// This handles the case where an article is bookmarked from the Details screen
  /// and the user returns to the Home feed.
  void _onBookmarksSyncRequested(
    HomeBookmarkSyncRequested event,
    Emitter<HomeState> emit,
  ) {
    // Skip sync if this article is currently being toggled by us.
    // The optimistic UI already shows the correct state, and processing
    // a stream event mid-toggle could override a rollback on failure.
    if (_inFlightToggles.contains(event.articleId)) return;

    final syncedArticles = state.articles.map((article) {
      if (article.id == event.articleId) {
        return article.copyWith(isSaved: event.isSaved);
      }
      return article;
    }).toList();

    emit(state.copyWith(articles: syncedArticles));
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categoriesResult = await _getCategoriesUseCase.call(isForHome: true);

    if (categoriesResult.isLeft()) {
      final failure = categoriesResult.fold((f) => f, (_) => null);
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure?.message,
        ),
      );
      return;
    }

    final categories = categoriesResult.fold((_) => null, (c) => c)!;

    // Correctly update state with ALL categories and set the initial selected category
    emit(
      state.copyWith(
        categories: categories,
        selectedCategory: categories.first,
      ),
    );

    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _onNextPageRequested(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    // droppable() handles the "already loading" case;
    // hasNextPage guard handles the "nothing more to load" case. They solve different problems.

    if (!state.hasNextPage) return; // Don't fetch if no more pages

    emit(state.copyWith(status: HomeStatus.loadingNextPage));
    await _fetchPage(emit, page: state.currentPage + 1, replace: false);
  }

  Future<void> _onCategoryChanged(
    HomeCategoryChanged event,
    Emitter<HomeState> emit,
  ) async {
    // CRITICAL: Update the state with the NEW category before calling _fetchPage
    emit(
      state.copyWith(
        selectedCategory: event.category,
        status: HomeStatus.loading,
        searchQuery: '',
        currentPage: 1,
        hasNextPage: true,
        articles: [], // Clear old articles for better UI transition
      ),
    );
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _onSearchChanged(
    HomeSearchSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    final trimmedQuery = event.query.trim();

    if (trimmedQuery == state.searchQuery && state.status == HomeStatus.loaded) {
      return;
    }

    // CRITICAL: Update the state with the NEW query before calling _fetchPage
    emit(
      state.copyWith(
        searchQuery: trimmedQuery,
        status: HomeStatus.loading,
        currentPage: 1,
        hasNextPage: true,
        articles: [],
      ),
    );
    await _fetchPage(emit, page: 1, replace: true);
  }

  /// Debounces events by [duration] and uses [restartable] to cancel in-flight
  /// search requests when a new debounced query arrives.
  EventTransformer<E> _debounceRestartable<E>(Duration duration) {
    return (events, mapper) {
      final debouncedEvents = events.transform(
        StreamTransformer<E, E>.fromBind((stream) {
          final controller = StreamController<E>(sync: true);
          Timer? timer;
          stream.listen(
            (event) {
              timer?.cancel();
              timer = Timer(duration, () {
                controller.add(event);
              });
            },
            onError: controller.addError,
            onDone: () {
              timer?.cancel();
              controller.close();
            },
          );
          return controller.stream;
        }),
      );
      return restartable<E>()(debouncedEvents, mapper);
    };
  }

  Future<void> _onBookmarkToggled(
    HomeBookmarkToggled event,
    Emitter<HomeState> emit,
  ) async {
    final articleId = event.article.id;

    // Prevent double-taps: ignore if this article is already being toggled
    if (_inFlightToggles.contains(articleId)) return;
    _inFlightToggles.add(articleId);

    // Capture the pre-toggle list for potential rollback
    final articles = state.articles;

    // Optimistic UI update: Toggle it locally first for instant feedback
    final optimisticArticles = articles.map((a) {
      if (a.id == articleId) {
        return a.copyWith(isSaved: !a.isSaved);
      }
      return a;
    }).toList();

    emit(state.copyWith(articles: optimisticArticles));

    try {
      // We intentionally pass event.article (the snapshot frozen at dispatch time),
      // NOT the article from the current state. event.article carries the original
      // isSaved value, which ToggleBookmarkUseCase needs to decide save vs. delete.
      final isToggleSucceeded = await _toggleBookmarkUseCase.call(
        article: event.article,
      );

      if (!isToggleSucceeded) {
        // Rollback: re-emit the original list. Equatable will detect the
        // difference (at least one article's isSaved differs) and trigger a rebuild.
        emit(state.copyWith(articles: articles));
      }
    } catch (e) {
      // On unexpected exceptions, roll back and log
      emit(state.copyWith(articles: articles));
      AppLogger.e('Bookmark toggle failed: $e');
    } finally {
      _inFlightToggles.remove(articleId);
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _fetchPage(
    Emitter<HomeState> emit, {
    required int page,
    required bool replace,
  }) async {
    final isSearchMode = state.searchQuery.isNotEmpty;

    if (isSearchMode) {
      final searchResult = await _searchNewsUseCase.call(
        query: state.searchQuery,
        page: page,
        pageSize: _pageSize,
      );

      searchResult.fold(
        (failure) => emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (articles) => _emitLoaded(emit, articles, replace, page),
      );

      return;
    }

    final categoryId = state.selectedCategory?.id;

    final result = await _fetchNewsUseCase.call(
      category: categoryId,
      page: page,
      pageSize: _pageSize,
    );

    result.fold((failure) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      );

      AppLogger.e(failure.message);
    }, (articles) => _emitLoaded(emit, articles, replace, page));
  }

  void _emitLoaded(
    Emitter<HomeState> emit,
    List<Article> articles,
    bool replace,
    int page,
  ) {
    final allArticles = replace ? articles : [...state.articles, ...articles];

    // Stamp isSaved from bookmarks storage.
    // This cross-references each article with the Bookmarks domain to set the
    // correct saved state. Done here in the BLoC (orchestration layer) rather
    // than inside FetchNewsUseCase/SearchNewsUseCase to avoid leaking Bookmarks
    // domain logic into the Home domain layer.
    final stampedArticles = allArticles.map((article) {
      return article.copyWith(
        isSaved: _checkIfSavedUseCase(article.id),
      );
    }).toList();

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        articles: stampedArticles,
        currentPage: page,
        hasNextPage: articles.length == _pageSize,
      ),
    );
  }

  @override
  Future<void> close() {
    _bookmarksSubscription?.cancel();
    return super.close();
  }
}
