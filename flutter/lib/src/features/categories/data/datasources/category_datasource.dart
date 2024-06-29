import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/data/dto/category_details_dto.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/categories/data/dto/category_dto.dart';
import 'package:habib_app/src/features/categories/data/datasources/category_datasource_impl.dart';
import 'package:habib_app/core/services/database.dart';

part 'category_datasource.g.dart';

@riverpod
CategoryDatasource categoryDatasource(CategoryDatasourceRef ref) {
  return CategoryDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class CategoryDatasource {

  const CategoryDatasource();

  Future<List<CategoryDto>> getCategories({ required String searchText, required int currentPage });

  Future<int> createCategory({
    required Json categoryJson
  });

  Future<CategoryDetailsDto> getCategory({ required int categoryId });

  Future<void> updateCategory({
    required int categoryId,
    required Json categoryJson
  });

  Future<void> deleteCategory({ required int categoryId });
}