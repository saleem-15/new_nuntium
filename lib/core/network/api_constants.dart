/*
class ApiConstants {
  ApiConstants._(); // منع إنشاء نسخة من الكلاس لأنه يحتوي على ثوابت فقط

  // -- Base Configuration --
  static const String baseUrl = "https://newsapi.org/v2";
  // It's recommended to store keys in .env file, but for now we keep it here as requested
  static const String apiKey = "8afe77481e534d1ab76a4dbf5d533508";
  static const String authorizationHeader = 'Authorization';

  // -- Timeouts --
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // -- Endpoints --
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // -- Pagination --
  static const int firstPageKey = 1;
  static const int homePageSizeValue = 20;
  static const String pageSize = 'pageSize';
  static const String page = 'page';

  // -- Request Parameters --
  static const String country = 'country';
  static const String category = 'category';
  static const String sources = 'sources';
  static const String search = 'q';

  // -- Response Keys --
  static const String status = 'status';
  static const String totalResults = 'totalResults';
  static const String articles = 'articles';
  static const String code = 'code'; // لالتقاط كود الخطأ من السيرفر
  static const String message = 'message'; // لالتقاط رسالة الخطأ من السيرفر

  // -- Article Object Keys --
  static const String title = 'title';
  static const String author = 'author';
  static const String description = 'description';
  static const String url = 'url';
  static const String urlToImage = 'urlToImage';
  static const String publishedAt = 'publishedAt';
  static const String content = 'content';

  // -- Source Object Keys --
  static const String source = 'source';
  static const String id = 'id';
  static const String name = 'name';

  // -- Messages --
  static const String noInternetConnection = 'No Internet connection';
}

*/

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // -- Base Configuration --
  static const String baseUrl = "https://newsapi.org/v2";
  static String apiKey = dotenv.env['API_KEY'] ?? "";

  // -- Timeouts --
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // -- Endpoints --
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // -- Params & Keys --
  static const String paramApiKey = 'apiKey';
  static const String paramQ = 'q';
  static const String paramCategory = 'category';
  static const String paramCountry = 'country';
  static const String paramPage = 'page';
  static const String paramPageSize = 'pageSize';

  // -- Default Values --
  static const int defaultPageSize = 20;
  static const String defaultCountry = 'us';
}
