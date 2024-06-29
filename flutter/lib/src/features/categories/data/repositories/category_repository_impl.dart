import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/categories/data/datasources/category_datasource.dart';
import 'package:habib_app/src/features/categories/data/dto/category_details_dto.dart';
import 'package:habib_app/src/features/categories/data/dto/category_dto.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {

  final CategoryDatasource _categoryDatasource;

  const CategoryRepositoryImpl({
    required CategoryDatasource categoryDatasource
  })  : _categoryDatasource = categoryDatasource;

  @override
  ResultFuture<List<CategoryEntity>> getCategories({ required String searchText, required int currentPage }) async {
    try {
      final List<CategoryDto> result = await _categoryDatasource.getCategories(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createCategory({
    required Json categoryJson
  }) async {
    try {
      final int categoryId = await _categoryDatasource.createCategory(categoryJson: categoryJson);
      return Success(categoryId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<CategoryDetailsEntity> getCategory({ required int categoryId }) async {
    try {
      final CategoryDetailsDto result = await _categoryDatasource.getCategory(categoryId: categoryId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updateCategory({
    required int categoryId,
    required Json categoryJson
  }) async {
    try {
      await _categoryDatasource.updateCategory(
        categoryId: categoryId,
        categoryJson: categoryJson
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deleteCategory({ required int categoryId }) async {
    try {
      await _categoryDatasource.deleteCategory(categoryId: categoryId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}