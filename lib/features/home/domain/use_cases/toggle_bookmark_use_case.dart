import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class ToggleBookmarkUseCase {
  final BookmarkRepository _repository;

  ToggleBookmarkUseCase(this._repository);

  Future<bool> call({required Article article}) async {
    // نتحقق من الحالة الحالية (سواء من الأوبجكت الممرر أو من الداتا بيس)
    // يفضل الاعتماد على الأوبجكت لسرعة الاستجابة، أو فحصه من الريبو إذا أردت دقة مطلقة
    if (article.isSaved) {
      await _repository.deleteBookmark(article.id);
    } else {
      await _repository.saveBookmark(article);
    }

    // نرجع الحالة الجديدة للتأكيد
    return _repository.isArticleSaved(article.id);
  }
}
