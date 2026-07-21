import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/core/models/article_hive_model.dart';
import 'package:nuntium/core/services/storage_service.dart';
import 'package:nuntium/features/bookmarks/data/repository/bookmark_repository_imp.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';

import '../../../../helpers/sample_news_response_json.dart';
import 'bookmark_repository_imp_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorageService;
  late BookmarkRepositoryImpl bookmarkRepository;

  setUp(() {
    mockStorageService = MockStorageService();
    bookmarkRepository = BookmarkRepositoryImpl(mockStorageService);
  });

  group('saveBookmark', () {
    test('should convert article to articleHiveModel before saving', () async {
      // Arrange
      final article = tArticlesList.first;
      final expectedArticle = ArticleHiveModel(
        id: article.id,
        title: article.title,
        category: article.category,
        sourceName: article.sourceName,
        imageUrl: article.imageUrl,
        content: article.content,
        url: article.url,
      );

      // Act
      await bookmarkRepository.saveBookmark(article);

      // Assert
      // This checks TWO things:
      // 1. Was saveBookmark called?
      // 2. Did ArticleHiveModel.fromEntity map EVERY SINGLE FIELD correctly?
      verify((mockStorageService.saveBookmark(expectedArticle))).called(1);
    });

    test(
      'Should Emit BookmarkChangeEvent.added when an article is saved',
      () async {
        // Arrange
        final article = tArticlesList.first;
        final expectedEvent = BookmarkChangeEvent(
          action: BookmarkAction.added,
          article: article,
        );

        // Assert (Set up stream listener FIRST)
        expectLater(bookmarkRepository.bookmarksStream, emits(expectedEvent));

        // Act
        await bookmarkRepository.saveBookmark(article);

        verify(
          mockStorageService.saveBookmark(ArticleHiveModel.fromEntity(article)),
        ).called(1);
      },
    );
  });

  group('deleteBookmark', () {
    test(
      'should delete bookmark by article ID',
      () async {
        // Arrange
        final article = tArticlesList.first;

        // Act
        await bookmarkRepository.deleteBookmark(article);

        // Assert
        verify(mockStorageService.deleteBookmark(article.id)).called(1);
      },
    );

    test(
      'Should Emit BookmarkChangeEvent.removed when an article is deleted',
      () async {
        // Arrange
        final article = tArticlesList.first;
        final expectedEvent = BookmarkChangeEvent(
          action: BookmarkAction.removed,
          article: article,
        );

        // Assert (Set up stream listener FIRST)
        expectLater(bookmarkRepository.bookmarksStream, emits(expectedEvent));

        // Act
        await bookmarkRepository.deleteBookmark(article);

        verify(mockStorageService.deleteBookmark(article.id)).called(1);
      },
    );
  });

  group('isArticleSaved', () {
    test('should return true when article exists in storage', () {
      // Arrange
      when(mockStorageService.isArticleSaved('123')).thenReturn(true);

      // Act
      final result = bookmarkRepository.isArticleSaved('123');

      // Assert
      expect(result, isTrue);
      verify(mockStorageService.isArticleSaved('123')).called(1);
    });
  });

  group('getSavedArticles', () {
    test('should return list of articles mapped from storage models', () {
      //Arrange
      final tHiveModel = ArticleHiveModel.fromEntity(tArticlesList.first);
      when(mockStorageService.getAllBookmarks()).thenReturn([tHiveModel]);

      //Act
      final result = bookmarkRepository.getSavedArticles();


      //Assert
      final expectedArticle = tArticlesList.first.copyWith(isSaved: true);
      expect(result, [expectedArticle]);
      verify(mockStorageService.getAllBookmarks()).called(1);
    });
  });
}
