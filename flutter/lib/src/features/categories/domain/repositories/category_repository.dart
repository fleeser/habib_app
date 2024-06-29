import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';
import 'package:habib_app/src/features/categories/data/datasources/category_datasource.dart';
import 'package:habib_app/src/features/categories/data/repositories/category_repository_impl.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_repository.g.dart';

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepositoryImpl(
    categoryDatasource: ref.read(categoryDatasourceProvider)
  );
}

abstract interface class CategoryRepository {

  ResultFuture<List<CategoryEntity>> getCategories({ required String searchText, required int currentPage });

  ResultFuture<int> createCategory({
    required Json categoryJson
  });

  ResultFuture<CategoryDetailsEntity> getCategory({ required int categoryId });

  ResultFuture<void> updateCategory({
    required int categoryId,
    required Json categoryJson
  });

  ResultFuture<void> deleteCategory({ required int categoryId });
}