import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/network/network_info.dart';
import 'package:nuntium/features/home/data/data_source/news_remote_data_source.dart';
import 'package:nuntium/features/home/data/repository/news_repository_impl.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';
import 'package:nuntium/core/entities/article.dart';

import 'news_repository_impl_test.mocks.dart';

@GenerateMocks([NewsRemoteDataSource, NetworkInfo, CrashReporter])
void main() {
  late MockNewsRemoteDataSource mockNewsRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockCrashReporter mockCrashReporter;
  late NewsRepository newsRepository;

  setUp(() {
    mockNewsRemoteDataSource = MockNewsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockCrashReporter = MockCrashReporter();

    getIt.registerLazySingleton<CrashReporter>(() => mockCrashReporter);

    newsRepository = NewsRepositoryImpl(
      mockNewsRemoteDataSource,
      mockNetworkInfo,
    );
  });

  tearDown(() {
    getIt.reset();
  });

  group('fetchNews', () {
    test("Should return Left(OfflineFailure) when device is offline", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await newsRepository.fetchNews(
        category: 'business',
        page: 1,
        pageSize: 10,
      );

      expect(result, const Left(OfflineFailure()));
    });

    test("Should return articles if successed", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockNewsRemoteDataSource.fetchTopHeadlines(
          category: 'business',
          pageSize: 10,
        ),
      ).thenAnswer((_) async => mockArticles);

      final result = await newsRepository.fetchNews(
        category: 'business',
        page: 1,
        pageSize: 10,
      );

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), mockCleanedArticles);
    });

    test(
      "Should return ServerFailure when ServerException is thrown by remote data source",
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockCrashReporter.reportError(
            exception: ServerException("Server Failed"),
            stackTrace: null,
          ),
        ).thenAnswer((_) async => {});

        when(
          mockNewsRemoteDataSource.fetchTopHeadlines(
            category: 'business',
            page: 1,
            pageSize: 10,
          ),
        ).thenThrow(ServerException("Server Failed"));

        final result = await newsRepository.fetchNews(
          category: 'business',
          page: 1,
          pageSize: 10,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold(
            (failure) => failure,
            (r) => fail("Should not have returned a Right value"),
          ),
          isA<ServerFailure>(),
        );
      },
    );

    test(
      'Should return UnknownFailure when any exception is thrown by remote data source',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockCrashReporter.reportError(
            exception: Exception("Unknown Error"),
            stackTrace: null,
          ),
        ).thenAnswer((_) async => {});

        when(
          mockNewsRemoteDataSource.fetchTopHeadlines(
            category: 'business',
            page: 1,
            pageSize: 10,
          ),
        ).thenThrow(Exception("Unknown Error"));

        final result = await newsRepository.fetchNews(
          category: 'business',
          page: 1,
          pageSize: 10,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold(
            (failure) => failure,
            (r) => fail("Should not have returned a Right value"),
          ),
          isA<UnkonwnFailure>(),
        );
      },
    );
  });
}

final List<Article> mockArticles = [
  Article(
    id: "https://finance.yahoo.com/markets/article/jpmorgan-notches-the-highest-quarterly-profit-in-us-banking-history-110031854.html",
    title:
        "JPMorgan notches the highest quarterly profit in US banking history - Yahoo Finance",
    category: "business",
    sourceName: "Yahoo Entertainment",
    imageUrl:
        "https://s.yimg.com/lo/mysterio/api/2D2B56DB13FF0DF66375C40FB934BD60F888E192484214A36AC184A6920BE747/subgraphmysterio/resizefill_w1200_h800;quality_80;format_webp/https:%2F%2Fd29szjachogqwa.cloudfront.net%2Fimages%2F2026-07%2F9b05e5b3-f3c0-4f68-be49-b849ce6afb6f",
    content:
        "The country's largest bank just raked in more quarterly profit than any US bank ever.\r\nJPMorgan Chase (JPM) said profits jumped 41% to \$21.2 billion in its second quarter, or \$7.70 per share, far exc… [+3552 chars]",
    url:
        "https://finance.yahoo.com/markets/article/jpmorgan-notches-the-highest-quarterly-profit-in-us-banking-history-110031854.html",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/14/ibm-warns-second-quarter-earnings-fell-short-of-expectations.html",
    title:
        "IBM shares skid more than 20% after company warns second-quarter earnings fell short of expectations - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108331548-1783441057395-108331548-1783440936777-gettyimages-2285063718-anotherday237785022_dhyo3ogk.jpg?v=1783441073&w=1920&h=1080",
    content:
        "International Business Machines shares slipped double digits on Tuesday after the hardware, software and consulting provider released preliminary second-quarter results that fell short of expectation… [+1123 chars]",
    url:
        "https://www.cnbc.com/2026/07/14/ibm-warns-second-quarter-earnings-fell-short-of-expectations.html",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/14/world-cups-semifinals-travel-to-host-cities-rises.html",
    title:
        "World Cup's biggest spenders show up late as semifinals drive host city travel boom - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108334598-1784029459756-gettyimages-2285092506-jr_16405_htnezmth.jpeg?v=1784029489&w=1920&h=1080",
    content:
        "The World Cup's biggest economic boost is arriving later than expected as the tournament enters its final days. \r\nBut for the U.S. businesses hoping for a soccer boom, it'sbetter late than never. \r\nT… [+3983 chars]",
    url:
        "https://www.cnbc.com/2026/07/14/world-cups-semifinals-travel-to-host-cities-rises.html",
  ),
  Article(
    id: "https://www.bbc.com/news/articles/c0ryr89gp09o?xtor=AL-72-%5Bpartner%5D-%5Byahoo.north.america%5D-%5Bheadline%5D-%5Bnews%5D-%5Bbizdev%5D-%5Bisapi%5D",
    title:
        "US burrito giant Chipotle opening first outlet in Mexico - Yahoo! Finance Canada",
    category: "business",
    sourceName: "BBC News",
    imageUrl:
        "https://s.yimg.com/lo/mysterio/api/8F980ED32362810076F23A363802F4D6F115A97F0F1C91D673A4FFECD5493E5D/subgraphmysterio/resizefill_w1200_h675;quality_80;format_webp/https:%2F%2Fmedia.zenfs.com%2Fen%2Fbbc_us_articles_995%2Ff5e58dd57e2935f384f47c52df101cba",
    content:
        "Chipotle Mexican Grill is set to open its first restaurant in Mexico this week, testing its appeal in the country that inspired its menu.\r\nThe chain, which has more than 4,100 outlets worldwide, said… [+2507 chars]",
    url:
        "https://www.bbc.com/news/articles/c0ryr89gp09o?xtor=AL-72-%5Bpartner%5D-%5Byahoo.north.america%5D-%5Bheadline%5D-%5Bnews%5D-%5Bbizdev%5D-%5Bisapi%5D",
  ),
  Article(
    id: "https://www.cnn.com/2026/07/14/economy/oil-diesel-gas-iran",
    title:
        "The world no longer has an oil problem. It has a gasoline problem - CNN",
    category: "business",
    sourceName: "CNN",
    imageUrl:
        "https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-2279516263.jpg?c=16x9&q=w_800,c_fill",
    content:
        "The largest-ever global oil supply shortage has topped economists lists of concerns since the start of the Iran war. But even as the United States and Iran resumed their blockades of the Strait of Ho… [+5430 chars]",
    url: "https://www.cnn.com/2026/07/14/economy/oil-diesel-gas-iran",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/13/stock-market-today-live-updates.html",
    title:
        "Stock futures are mixed as Middle East tensions escalate; traders await earnings and inflation data: Live updates - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108265608-1770996501376-gettyimages-2261448828-anotherday183751646_ugavhh0v.jpeg?v=1770996558&w=1920&h=1080",
    content:
        "S&amp;P 500 futures rose on Tuesday after June inflation data came in weaker than expected. Traders also assessed rising oil prices and a slew of corporate earnings releases.\r\nFutures tied to the bro… [+2242 chars]",
    url: "https://www.cnbc.com/2026/07/13/stock-market-today-live-updates.html",
  ),
  Article(
    id: "https://www.foxbusiness.com/personal-finance/why-ramsey-financial-expert-says-no-magic-age-claim-social-security",
    title:
        "Why Ramsey financial expert says there's 'no magic age' to claim Social Security - Fox Business",
    category: "business",
    sourceName: "Fox Business",
    imageUrl:
        "https://a57.foxnews.com/static.foxbusiness.com/foxbusiness.com/content/uploads/2026/07/0/0/social-security-protest-md.jpg?ve=1&tl=1",
    content:
        "As anxiety mounts over the projected 2032 depletion of the Social Security Old-Age and Survivors Insurance (OASI) Trust Fund, a viral online trend is urging Americans to claim their retirement benefi… [+5421 chars]",
    url:
        "https://www.foxbusiness.com/personal-finance/why-ramsey-financial-expert-says-no-magic-age-claim-social-security",
  ),
  Article(
    id: "https://nypost.com/2026/07/14/world-news/wife-who-held-onto-husbands-legs-to-stop-him-being-sucked-out-of-ryanair-plane-window-thought-if-we-die-we-die-together/",
    title:
        "Wife who held onto husband’s legs to stop him being sucked out of plane window thought ‘If we die, we die together’ - New York Post",
    category: "business",
    sourceName: "New York Post",
    imageUrl:
        "https://nypost.com/wp-content/uploads/sites/2/2026/07/134325509.jpg?quality=75&strip=all&w=1200",
    content:
        "A wife who grabbed onto her husbands legs to stop him being sucked out of a broken Ryanair plane window at 20,000 feet has told of the frantic bid to save him and revealed she thought If we die, we d… [+1940 chars]",
    url:
        "https://nypost.com/2026/07/14/world-news/wife-who-held-onto-husbands-legs-to-stop-him-being-sucked-out-of-ryanair-plane-window-thought-if-we-die-we-die-together/",
  ),
  Article(
    id: "https://www.businessinsider.com/michael-dell-donald-trump-relationship-business-politics-2026-7#article",
    title:
        "Michael Dell has nailed his relationship with Donald Trump, and it's paying off - Business Insider",
    category: "business",
    sourceName: "Business Insider",
    imageUrl:
        "https://i.insider.com/6a4d1c9b5dc133dbf310da12?width=1200&format=jpeg",
    content:
        "It's a good year to be Michael Dell.\r\nHis net worth is up over \$80 billion. His company's shares have risen 240% as it rides a wave of AI-driven growth. And, critically, Dell, 61, has found favor wit… [+7839 chars]",
    url:
        "https://www.businessinsider.com/michael-dell-donald-trump-relationship-business-politics-2026-7#article",
  ),
  Article(
    id: "https://www.axios.com/2026/07/14/demis-hassabis-ai-regulation-google-deepmind",
    title:
        "Exclusive: Google DeepMind's Demis Hassabis calls for U.S.-led global AI watchdog - Axios",
    category: "business",
    sourceName: "Axios",
    imageUrl:
        "https://images.axios.com/vgYN9JCvRj-KvyX8nKBrcfAn4Q8=/0x343:4714x2995/1366x768/2026/07/13/1783982748120.jpg",
    content:
        "Demis Hassabis, Google DeepMind co-founder and CEO, is calling on the U.S. to establish a new AI watchdog with the power to screen the world's most advanced models and coordinate an industry-wide slo… [+4158 chars]",
    url:
        "https://www.axios.com/2026/07/14/demis-hassabis-ai-regulation-google-deepmind",
  ),
];

final List<Article> mockCleanedArticles = [
  Article(
    id: "https://finance.yahoo.com/markets/article/jpmorgan-notches-the-highest-quarterly-profit-in-us-banking-history-110031854.html",
    title:
        "JPMorgan notches the highest quarterly profit in US banking history - Yahoo Finance",
    category: "business",
    sourceName: "Yahoo Entertainment",
    imageUrl:
        "https://s.yimg.com/lo/mysterio/api/2D2B56DB13FF0DF66375C40FB934BD60F888E192484214A36AC184A6920BE747/subgraphmysterio/resizefill_w1200_h800;quality_80;format_webp/https:%2F%2Fd29szjachogqwa.cloudfront.net%2Fimages%2F2026-07%2F9b05e5b3-f3c0-4f68-be49-b849ce6afb6f",
    content:
        "The country's largest bank just raked in more quarterly profit than any US bank ever.\r\nJPMorgan Chase (JPM) said profits jumped 41% to \$21.2 billion in its second quarter, or \$7.70 per share, far exc…",
    url:
        "https://finance.yahoo.com/markets/article/jpmorgan-notches-the-highest-quarterly-profit-in-us-banking-history-110031854.html",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/14/ibm-warns-second-quarter-earnings-fell-short-of-expectations.html",
    title:
        "IBM shares skid more than 20% after company warns second-quarter earnings fell short of expectations - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108331548-1783441057395-108331548-1783440936777-gettyimages-2285063718-anotherday237785022_dhyo3ogk.jpg?v=1783441073&w=1920&h=1080",
    content:
        "International Business Machines shares slipped double digits on Tuesday after the hardware, software and consulting provider released preliminary second-quarter results that fell short of expectation…",
    url:
        "https://www.cnbc.com/2026/07/14/ibm-warns-second-quarter-earnings-fell-short-of-expectations.html",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/14/world-cups-semifinals-travel-to-host-cities-rises.html",
    title:
        "World Cup's biggest spenders show up late as semifinals drive host city travel boom - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108334598-1784029459756-gettyimages-2285092506-jr_16405_htnezmth.jpeg?v=1784029489&w=1920&h=1080",
    content:
        "The World Cup's biggest economic boost is arriving later than expected as the tournament enters its final days. \r\nBut for the U.S. businesses hoping for a soccer boom, it'sbetter late than never. \r\nT…",
    url:
        "https://www.cnbc.com/2026/07/14/world-cups-semifinals-travel-to-host-cities-rises.html",
  ),
  Article(
    id: "https://www.bbc.com/news/articles/c0ryr89gp09o?xtor=AL-72-%5Bpartner%5D-%5Byahoo.north.america%5D-%5Bheadline%5D-%5Bnews%5D-%5Bbizdev%5D-%5Bisapi%5D",
    title:
        "US burrito giant Chipotle opening first outlet in Mexico - Yahoo! Finance Canada",
    category: "business",
    sourceName: "BBC News",
    imageUrl:
        "https://s.yimg.com/lo/mysterio/api/8F980ED32362810076F23A363802F4D6F115A97F0F1C91D673A4FFECD5493E5D/subgraphmysterio/resizefill_w1200_h675;quality_80;format_webp/https:%2F%2Fmedia.zenfs.com%2Fen%2Fbbc_us_articles_995%2Ff5e58dd57e2935f384f47c52df101cba",
    content:
        "Chipotle Mexican Grill is set to open its first restaurant in Mexico this week, testing its appeal in the country that inspired its menu.\r\nThe chain, which has more than 4,100 outlets worldwide, said…",
    url:
        "https://www.bbc.com/news/articles/c0ryr89gp09o?xtor=AL-72-%5Bpartner%5D-%5Byahoo.north.america%5D-%5Bheadline%5D-%5Bnews%5D-%5Bbizdev%5D-%5Bisapi%5D",
  ),
  Article(
    id: "https://www.cnn.com/2026/07/14/economy/oil-diesel-gas-iran",
    title:
        "The world no longer has an oil problem. It has a gasoline problem - CNN",
    category: "business",
    sourceName: "CNN",
    imageUrl:
        "https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-2279516263.jpg?c=16x9&q=w_800,c_fill",
    content:
        "The largest-ever global oil supply shortage has topped economists lists of concerns since the start of the Iran war. But even as the United States and Iran resumed their blockades of the Strait of Ho…",
    url: "https://www.cnn.com/2026/07/14/economy/oil-diesel-gas-iran",
  ),
  Article(
    id: "https://www.cnbc.com/2026/07/13/stock-market-today-live-updates.html",
    title:
        "Stock futures are mixed as Middle East tensions escalate; traders await earnings and inflation data: Live updates - CNBC",
    category: "business",
    sourceName: "CNBC",
    imageUrl:
        "https://image.cnbcfm.com/api/v1/image/108265608-1770996501376-gettyimages-2261448828-anotherday183751646_ugavhh0v.jpeg?v=1770996558&w=1920&h=1080",
    content:
        "S&P 500 futures rose on Tuesday after June inflation data came in weaker than expected. Traders also assessed rising oil prices and a slew of corporate earnings releases.\r\nFutures tied to the bro…", // Cleaned S&amp;P -> S&P
    url: "https://www.cnbc.com/2026/07/13/stock-market-today-live-updates.html",
  ),
  Article(
    id: "https://www.foxbusiness.com/personal-finance/why-ramsey-financial-expert-says-no-magic-age-claim-social-security",
    title:
        "Why Ramsey financial expert says there's 'no magic age' to claim Social Security - Fox Business",
    category: "business",
    sourceName: "Fox Business",
    imageUrl:
        "https://a57.foxnews.com/static.foxbusiness.com/foxbusiness.com/content/uploads/2026/07/0/0/social-security-protest-md.jpg?ve=1&tl=1",
    content:
        "As anxiety mounts over the projected 2032 depletion of the Social Security Old-Age and Survivors Insurance (OASI) Trust Fund, a viral online trend is urging Americans to claim their retirement benefi…",
    url:
        "https://www.foxbusiness.com/personal-finance/why-ramsey-financial-expert-says-no-magic-age-claim-social-security",
  ),
  Article(
    id: "https://nypost.com/2026/07/14/world-news/wife-who-held-onto-husbands-legs-to-stop-him-being-sucked-out-of-ryanair-plane-window-thought-if-we-die-we-die-together/",
    title:
        "Wife who held onto husband’s legs to stop him being sucked out of plane window thought ‘If we die, we die together’ - New York Post",
    category: "business",
    sourceName: "New York Post",
    imageUrl:
        "https://nypost.com/wp-content/uploads/sites/2/2026/07/134325509.jpg?quality=75&strip=all&w=1200",
    content:
        "A wife who grabbed onto her husbands legs to stop him being sucked out of a broken Ryanair plane window at 20,000 feet has told of the frantic bid to save him and revealed she thought If we die, we d…",
    url:
        "https://nypost.com/2026/07/14/world-news/wife-who-held-onto-husbands-legs-to-stop-him-being-sucked-out-of-ryanair-plane-window-thought-if-we-die-we-die-together/",
  ),
  Article(
    id: "https://www.businessinsider.com/michael-dell-donald-trump-relationship-business-politics-2026-7#article",
    title:
        "Michael Dell has nailed his relationship with Donald Trump, and it's paying off - Business Insider",
    category: "business",
    sourceName: "Business Insider",
    imageUrl:
        "https://i.insider.com/6a4d1c9b5dc133dbf310da12?width=1200&format=jpeg",
    content:
        "It's a good year to be Michael Dell.\r\nHis net worth is up over \$80 billion. His company's shares have risen 240% as it rides a wave of AI-driven growth. And, critically, Dell, 61, has found favor wit…",
    url:
        "https://www.businessinsider.com/michael-dell-donald-trump-relationship-business-politics-2026-7#article",
  ),
  Article(
    id: "https://www.axios.com/2026/07/14/demis-hassabis-ai-regulation-google-deepmind",
    title:
        "Exclusive: Google DeepMind's Demis Hassabis calls for U.S.-led global AI watchdog - Axios",
    category: "business",
    sourceName: "Axios",
    imageUrl:
        "https://images.axios.com/vgYN9JCvRj-KvyX8nKBrcfAn4Q8=/0x343:4714x2995/1366x768/2026/07/13/1783982748120.jpg",
    content:
        "Demis Hassabis, Google DeepMind co-founder and CEO, is calling on the U.S. to establish a new AI watchdog with the power to screen the world's most advanced models and coordinate an industry-wide slo…",
    url:
        "https://www.axios.com/2026/07/14/demis-hassabis-ai-regulation-google-deepmind",
  ),
];
