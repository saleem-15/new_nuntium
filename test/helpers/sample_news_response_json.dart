import 'package:nuntium/core/entities/article.dart';

/// Item 1 (Standard Valid Article): Tests normal mapping of all fields.
///
/// Item 2 (Defensive / Fallback Article): Tests nullable fields (e.g. description: null, author: null, source.id: null) to ensure fallback logic (?? '') works without throwing a Null error.
///
/// Item 3 (Removed Article): Tests custom filtering logic (where title != '[Removed]') to verify it gets filtered out of the final list.
final tNewsJsonResponse = {
  "status": "ok",
  "totalResults": 3,
  "articles": [
    {
      "source": {"id": "cnn", "name": "CNN"},
      "author": "Hanna Park, Dalia Faheid",
      "title":
          "At least 2 dead in Texas floods as hundreds rescued in same region as Camp Mystic disaster - CNN",
      "description":
          "Disastrous flash flooding has hit southern Texas after days of torrential rain.",
      "url":
          "https://www.cnn.com/2026/07/17/weather/texas-flooding-risks-damage-hnk",
      "urlToImage":
          "https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-2286432846.jpg",
      "publishedAt": "2026-07-17T09:20:30Z",
      "content": "Disastrous flash flooding has hit southern Texas...",
    },
    {
      "source": {"id": null, "name": "Suntimes.com"},
      "author": null,
      "title": "Horoscope for Friday, July 17, 2026 - Chicago Sun-Times",
      "description": null,
      "url":
          "https://chicago.suntimes.com/horoscopes/2026/07/17/horoscopes-today-friday-july-17-2026",
      "urlToImage": null,
      "publishedAt": "2026-07-17T05:01:00Z",
      "content": "Moon alert...",
    },
    {
      "source": {"id": null, "name": "NewsAPI"},
      "author": null,
      "title": "[Removed]",
      "description": "[Removed]",
      "url": "https://newsapi.org/removed",
      "urlToImage": null,
      "publishedAt": "2026-07-17T00:00:00Z",
      "content": "[Removed]",
    },
  ],
};

final tArticlesList = [
  Article(
    id: 'https://www.cnn.com/2026/07/17/weather/texas-flooding-risks-damage-hnk',
    title:
        'At least 2 dead in Texas floods as hundreds rescued in same region as Camp Mystic disaster - CNN',
    category: 'general',
    sourceName: 'CNN',
    imageUrl:
        'https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-2286432846.jpg',
    content: 'Disastrous flash flooding has hit southern Texas...',
    url:
        'https://www.cnn.com/2026/07/17/weather/texas-flooding-risks-damage-hnk',
  ),
  Article(
    id: 'https://chicago.suntimes.com/horoscopes/2026/07/17/horoscopes-today-friday-july-17-2026',
    title: 'Horoscope for Friday, July 17, 2026 - Chicago Sun-Times',
    category: 'general',
    sourceName: 'Suntimes.com',
    imageUrl: 'https://placehold.co/600x400',
    content: 'Moon alert...',
    url:
        'https://chicago.suntimes.com/horoscopes/2026/07/17/horoscopes-today-friday-july-17-2026',
  ),
];
