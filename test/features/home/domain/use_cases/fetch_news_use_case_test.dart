import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';
import 'package:nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';

import '../../data/repository/news_repository_impl_test.dart';
import 'fetch_news_use_case_test.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late MockNewsRepository mockNewsRepository;
  late FetchNewsUseCase fetchNewsUseCase;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    fetchNewsUseCase = FetchNewsUseCase(mockNewsRepository);
  });

  test('should pass the call to the repository', () async {
    when(
      mockNewsRepository.fetchNews(category: 'business', page: 1, pageSize: 10),
    ).thenAnswer((_) async => Right(mockCleanedArticles));

    final result = await fetchNewsUseCase.call(
      category: 'business',
      page: 1,
      pageSize: 10,
    );

    //check the return value
    expect(
      result,
      right(mockCleanedArticles),
    );

    // check if the usecase called the repository with the exact parametrs
    // and called only once
    verify(
      mockNewsRepository.fetchNews(category: 'business', page: 1, pageSize: 10),
    ).called(1);

    verifyNoMoreInteractions(mockNewsRepository);
  });
}
