import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/features/categories/domain/repository/cateogries_repository.dart';

import '../entities/category_entity.dart';

class GetCategoriesUseCase {
  final CategoriesRepository categoriesRepository;

  GetCategoriesUseCase(this.categoriesRepository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return categoriesRepository.getCategories();
  }
}
