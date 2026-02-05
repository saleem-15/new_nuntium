import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repository/cateogries_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  @override
  Either<Failure, List<CategoryEntity>> getCategories()  {
    return Right([
      CategoryEntity(
        id: 'general',
        name: AppStrings.general,
        iconPath: AppAssets.science,
      ),
      CategoryEntity(
        id: 'sports',
        name: AppStrings.sports,
        iconPath: AppAssets.sports,
      ),
      CategoryEntity(
        id: 'business',
        name: AppStrings.business,
        iconPath: AppAssets.business,
      ),
      CategoryEntity(
        id: 'science',
        name: AppStrings.science,
        iconPath: AppAssets.science,
      ),
      CategoryEntity(
        id: 'entertainment',
        name: AppStrings.entertainment,
        iconPath: AppAssets.entertainment,
      ),
      CategoryEntity(
        id: 'technology',
        name: AppStrings.technology,
        iconPath: AppAssets.technology,
      ),
    ]);
  }
}
