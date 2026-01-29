import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:share_plus/share_plus.dart';

class ArticleController extends GetxController {
  ArticleController({required this.article});
  Article article;

  // Use Cases
  final _toggleBookmarkUseCase = getIt<ToggleBookmarkUseCase>();
  final _watchBookmarksUseCase = getIt<WatchBookmarksChangesUseCase>();

  @override
  void onInit() {
    super.onInit();

    _listenToBookmarkChanges();
  }

  ///  Listens to article Bookmark changes and updates the UI accordingly
  void _listenToBookmarkChanges() {
    _watchBookmarksUseCase.call().listen((BookmarkChangeEvent event) {
      final isSaved = event.action == BookmarkAction.added;
      final eventArticleId = event.article.id;

      if (article.id == eventArticleId) {
        article.isSaved = isSaved;
        update([eventArticleId]);
      }
    });
  }

  Future<void> onBookmarkPressed() async {
    final newState = await _toggleBookmarkUseCase.call(article: article);
    article.isSaved = newState;
  }

  void onSharePressed() {
    SharePlus.instance.share(ShareParams(text: article.url));
  }

  void onBackPressed() {
    Get.back();
  }
}
