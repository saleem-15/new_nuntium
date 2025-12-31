import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:new_nuntium/features/home/data/news_model.dart';

class BookmarksController extends GetxController {
  final List<News> bookmarks = [
    News(
      id: '1',
      category: 'POLITICS',
      title: 'The latest situation in the presidential election',
      imageUrl:
          'https://travel.usnews.com/dims4/USNEWS/cf429aa/2147483647/resize/976x652%5E%3E/crop/976x652/quality/85/format/webp/?url=https%3A%2F%2Ftravel.usnews.com%2Fimages%2FCapitol1_Getty.jpg',
    ),
    News(
      id: '2',
      category: 'ART',
      title: 'An updated daily front page',
      imageUrl:
          'https://www.edenart.com/_next/image?url=https%3A%2F%2Fsrv-1.eden-gallery.com%2F2021%2F08%2F11%2F6113d70d63ca0-What-is-Fine-Art--Eden-Gallery-.jpeg&w=1920&q=75',
    ),
    News(
      id: '3',
      category: 'Sports',
      title: 'The impact of technology on modern football',
      imageUrl:
          'https://www.newsclick.in/sites/default/files/styles/responsive_885/public/2018-07/N%27Golo%20Kante%20and%20Lionel%20Messi.jpg',
    ),
    News(
      id: '4',
      category: 'Gaming',
      title: 'Next-gen consoles: What to expect in 2026',
      imageUrl:
          'https://cdn.thewirecutter.com/wp-content/media/2023/05/gamingconsoles-2048px-00730-3x2-1.jpg?auto=webp&quality=75&width=980&dpr=2',
    ),
  ];

  void onArticleTapped(News tappedArticle) {}

  void fetchBookmarksIfNeeded() {}
}
