// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:new_nuntium/core/models/article.dart';
// import 'package:new_nuntium/core/network/api_client.dart';
// import 'package:new_nuntium/core/network/api_constants.dart';
// import 'package:new_nuntium/features/home/data/data_source/news_remote_data_source.dart';

// import 'news_remote_data_source_test.mocks.dart';

// @GenerateMocks([NewsRemoteDataSource, ApiClient])
// Future<void> main() async {
//   test('Remote data source outputs List of Articles', () async {
//     final mockApiClient = MockApiClient();
//     final newsDataSource = NewsRemoteDataSource(mockApiClient);

//     when(
//       mockApiClient.get(
//         ApiConstants.topHeadlines,
//         queryParams: anyNamed('queryParams'),
//       ),
//     ).thenAnswer(
//       (_) async => Response(
//         requestOptions: RequestOptions(
//           path: '${ApiConstants.baseUrl}${ApiConstants.topHeadlines}',
//         ),
//         data: tJson,
//         statusCode: 200,
//       ),
//     );
//     final result = await newsDataSource.fetchTopHeadlines(
//       category: 'general',
//       page: 1,
//       pageSize: 20,
//     );

//     expect(result, isA<List<Article>>());
//     expect(result.length, 1);
//   });

//   test('UnknowmException', () async {
//     final apiClient = MockApiClient();
//     final newsSource = NewsRemoteDataSource(apiClient);

//     when(
//       apiClient.get(
//         ApiConstants.topHeadlines,
//         queryParams: anyNamed('queryParams'),
//       ),
//     ).thenAnswer(
//       (_) async => Response(
//         requestOptions: RequestOptions(path: ApiConstants.topHeadlines),
//         data: {},
//         statusCode: 500,
//       ),
//     );

//     expect(
//       newsSource.fetchTopHeadlines(category: 'general'),
//       throwsA(isA<Exception>()),
//     );
//   });
// }

// final tJson = {
//   "status": "ok",
//   "totalResults": 1,
//   "articles": [
//     {
//       "source": {"id": null, "name": "Test Source"},
//       "author": "Test Author",
//       "title": "Test Title",
//       "description": "Test Description",
//       "url": "https://test.com",
//       "urlToImage": "https://test.com/image.png",
//       "publishedAt": "2026-01-27T00:00:00Z",
//       "content": "Test Content",
//     },
//   ],
// };
// List<Article> articlesList = [
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "India and European Union have closed a 'landmark' free trade deal, Prime Minister Modi says - CNBC",
//     url:
//         "https://www.cnbc.com/2026/01/27/india-eu-trade-deal-trump-tariffs.html",
//     imageUrl:
//         "https://image.cnbcfm.com/api/v1/image/108256077-1769130512349-gettyimages-2201750008-AFP_36YV72E.jpeg?v=1769130529&w=1920&h=1080",
//     content:
//         "India and the European Union on Monday closed a \"landmark\" free trade agreement, touted as the 'mother of all deals,' Indian Prime Minister Narendra Modi said during a speech at the India Energy Week… [+3273 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Chris Mason: Both Tories and Labour feel the Reform heebie-jeebies - BBC",
//     url: "https://www.bbc.com/news/articles/c5yv97e7j5lo",
//     imageUrl:
//         "https://ichef.bbci.co.uk/news/1024/branded_news/36e1/live/aeddc6d0-fb2f-11f0-b385-5f48925de19a.jpg",
//     content:
//         "Chris MasonPolitical editor\r\nBoth of Westminster's mega brands, Labour and the Conservatives, feel discombobulated and the discombobulator-in-chief is the Reform UK leader, Nigel Farage.\r\nThe thing t… [+2865 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "'Major step': French MPs vote in favour of bill to ban social media for under-15s - BBC",
//     url: "https://www.bbc.com/news/articles/c07x003vx0yo",
//     imageUrl:
//         "https://ichef.bbci.co.uk/news/1024/branded_news/053a/live/4c7fd700-fab0-11f0-91f4-a739ab96be22.jpg",
//     content:
//         "France's National Assembly has backed a bill that would bansocial media access for under-15s, a proposal supported by President Emmanuel Macron.\r\nLawmakers in the lower house on Monday agreed key ele… [+3818 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Marc Ross: 'McCarthy probably would have been a better fit for an organization like Tennessee... but you can't argue with what he's done' | 'The Insiders' - NFL.com",
//     url:
//         "https://www.nfl.com/videos/marc-ross-mccarthy-probably-would-have-been-a-better-fit-for-an-organization-like-tennessee-but-you-can-t-argue-with-what-he-s-done-the-insiders",
//     imageUrl:
//         "https://static.www.nfl.com/image/upload/t_editorial_landscape_12_desktop/league/fiyignupcop9i4ulct1v",
//     content: 'null',
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title: "Menopause linked to Alzheimer's-like brain changes - BBC",
//     url: "https://www.bbc.com/news/articles/c9qpp1g5ylvo",
//     imageUrl:
//         "https://ichef.bbci.co.uk/news/1024/branded_news/dd77/live/8b531fd0-fae9-11f0-a422-4ba8a094a8fa.jpg",
//     content:
//         "Michelle RobertsDigital health editor\r\nThe menopause is linked to changes in the brain similar to those seen in Alzheimer's, according to a large UK study.\r\nThe loss of grey matter in areas involved … [+2859 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "iPhone 5s Gets New Software Update 13 Years After Launch - MacRumors",
//     url: "https://www.macrumors.com/2026/01/26/iphone-5s-software-update/",
//     imageUrl:
//         "https://images.macrumors.com/t/ngkAi3w6nDMDcpgrGD3TE21HlGY=/1600x/article-new/2024/05/iPhone-5s-16x9.jpeg",
//     content:
//         "Alongside iOS 26.2.1, Apple today released an updated version of iOS 12 for devices that are still running that operating system update, eight years after the software was first released.\r\niOS 12.5.8… [+1294 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "North West Calls Mom Kim Kardashian ‘the Goat’ During Livestream: ‘I Hope Someone Recorded That’ - Yahoo",
//     url:
//         "https://globemagazine.com/north-west-calls-mom-kim-kardashian-the-goat-during-livestream-i-hope-someone-recorded-that/",
//     imageUrl:
//         "https://globemagazine.com/wp-content/uploads/2026/01/Featured-6-Kim-Kardashian-North-West-1000x600.jpeg",
//     content:
//         "Crash / MediaPunch / MEGA;TikTok/kimandnorth\r\nKim Kardashian was given the highest praise by daughter North West.\r\nWest, 12, was being monitored by her mother, 45, while she chatted with fans on soci… [+1351 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Dozens of CDC databases are not being updated — most related to vaccines, study finds - NBC News",
//     url:
//         "https://www.nbcnews.com/health/health-news/cdc-databases-not-updated-vaccines-study-rcna255467",
//     imageUrl:
//         "https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2025-10/251013-cdc-mb-0631-0a730e.jpg",
//     content:
//         "Nearly half of the databases that the Centers for Disease Control and Prevention used to update regularly surveillance systems that tracked public health information like Covid vaccination rates and … [+6187 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Walz says Trump pledged to ‘do things differently’ on ICE surge - mprnews.org",
//     url:
//         "https://www.mprnews.org/story/2026/01/26/gov-tim-walzs-first-sit-down-interview-since-dropping-out-of-2026-race",
//     imageUrl:
//         "https://img.apmcdn.org/a89f762ed0689633d90d78dec9d6752339b66060/widescreen/baa07d-20260121-border-patrol-bovino-04-2000.jpg",
//     content: 'null',
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Neil Young Trashes Amazon, Gives His Complete Musical Catalog to Greenland for Free - Rolling Stone",
//     url:
//         "http://www.rollingstone.com/music/music-news/neil-young-trashes-amazon-greenland-free-music-1235505119/",
//     imageUrl:
//         "https://www.rollingstone.com/wp-content/uploads/2026/01/neil-young-amazon.jpg?crop=0px%2C21px%2C1800px%2C1014px&resize=1600%2C900",
//     content:
//         "Back in October, Neil Youngpledged to remove all of his music from Amazon. And in a recent post on the Neil Young Archives, he said he’s sticking with the plan.\r\n“Amazon is owned by Jeff Bezos, a bil… [+2791 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "This is Android 17’s blur, new screen recorder, & more in leaked screenshots [Gallery] - 9to5Google",
//     url: "http://9to5google.com/2026/01/26/android-17-leak/",
//     imageUrl:
//         "https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2025/03/Android-Bot-minifig-1.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1",
//     content:
//         "The Android 17 leaks continue today with a preview of the upcoming blur effect for System UI, as well as functional changes and updates.\r\nRKBDI provided us with an early look at an internal Android 1… [+1388 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Why Seahawks’ NFC title win was historic and fortunate | Four Downs - The Seattle Times",
//     url:
//         "https://www.seattletimes.com/sports/seahawks/why-seahawks-nfc-title-win-was-historic-and-fortunate-four-downs/",
//     imageUrl:
//         "https://images.seattletimes.com/wp-content/uploads/2026/01/01262026_Seahawks-Macdonald_tzr_131853.jpg?d=1200x630",
//     content:
//         "An hour or so before Sundays NFC title game, the two participants in one of the most iconic phrases in Seahawks history Richard Sherman and Tom Brady reunited on the surface of Lumen Field.\r\nBrady wa… [+6619 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Former Citigroup executive sues bank over handling of sexual harassment claims - Financial Times",
//     url: "https://www.ft.com/content/6b539d0f-d469-40ad-a967-5d712221038a",
//     imageUrl:
//         "https://images.ft.com/v3/image/raw/https%3A%2F%2Fd1e00ek4ebabms.cloudfront.net%2Fproduction%2F73420471-769f-41bc-94e5-87b5bd0e048a.jpg?source=next-barrier-page",
//     content:
//         "was undefinednow undefined for your first year\r\nDelivery Monday - Saturday, including FT Weekend and FT Digital Edition: all the content of the FT newspaper on any device. Savings based on annual pri… [+231 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Dollar slides to 4-month low on efforts to boost the yen, which could spell trouble for U.S. equities - MarketWatch",
//     url:
//         "https://www.marketwatch.com/story/dollar-slides-to-4-month-low-on-efforts-to-boost-the-yen-which-could-spell-trouble-for-u-s-equities-fd1d66f3",
//     imageUrl: "https://images.mktw.net/im-64691011/social",
//     content:
//         "The U.S. dollar took another hit on Monday, weakening to its lowest levels in four months, as talk of a coordinated intervention to prop up the competing Japanese yen intensified. \r\nA stronger Japane… [+185 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Treasury cancels Booz Allen contracts over leaks about wealthy taxpayers - NPR",
//     url:
//         "https://www.npr.org/2026/01/26/nx-s1-5689010/treasury-cancels-booz-allen-contracts-irs-leak",
//     imageUrl:
//         "https://npr.brightspotcdn.com/dims3/default/strip/false/crop/7683x4322+0+400/resize/1400/quality/85/format/jpeg/?url=http%3A%2F%2Fnpr-brightspot.s3.amazonaws.com%2Ffd%2Fc1%2F274803074cc493ed6015283c0864%2Fgettyimages-2209831945.jpg",
//     content:
//         "The Treasury Department is canceling millions of dollars worth of contracts with the Booz Allen Hamilton consulting firm, after a contractor from the firm leaked confidential IRS information, showing… [+1522 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title: "Marburg virus disease - Ethiopia - World Health Organization (WHO)",
//     url:
//         "https://www.who.int/emergencies/disease-outbreak-news/item/2026-DON592",
//     imageUrl: 'null',
//     content:
//         "Situation at a glance\r\nOn 26 January 2026, the Ministry of Health of Ethiopia declared the end of the Marburg virus disease (MVD) outbreak. This declaration came after two consecutive incubation peri… [+18711 chars]",
//   ),
//   Article(
//     id: '1',
//     category: 'general',
//     sourceName: 'Mock data',
//     title:
//         "Marshall does not plan to offer credit card amendment at crypto markup - Politico",
//     url:
//         "https://www.politico.com/live-updates/2026/01/26/congress/marshall-credit-card-amendment-crypto-markup-00746918",
//     imageUrl:
//         "https://www.politico.com/dims4/default/d00ca85/2147483647/resize/1200x/quality/90/?url=https%3A%2F%2Fstatic.politico.com%2F07%2F4c%2Ff20f31cf4fd1a5d8551789ee0e66%2Fhttps-delivery-gettyimages.com%2Fdownloads%2F2225268463",
//     content: 'null',
//   ),
// ];
