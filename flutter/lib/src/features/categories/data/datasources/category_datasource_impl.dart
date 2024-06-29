import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/categories/data/datasources/category_datasource.dart';
import 'package:habib_app/src/features/categories/data/dto/category_details_dto.dart';
import 'package:habib_app/src/features/categories/data/dto/category_dto.dart';

class CategoryDatasourceImpl implements CategoryDatasource {

  final Database _database;

  const CategoryDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<CategoryDto>> getCategories({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getCategories(
      searchText: searchText, 
      currentPage: currentPage
    );
    return CategoryDto.listFromJsonList(jsonList);
  }

  @override
  Future<int> createCategory({
    required Json categoryJson
  }) async {
    return await _database.createCategory(categoryJson: categoryJson);
  }

  @override
  Future<CategoryDetailsDto> getCategory({ required int categoryId }) async {
    final Json json = await _database.getCategory(categoryId: categoryId);
    return CategoryDetailsDto.fromJson(json);
  }

  @override
  Future<void> updateCategory({
    required int categoryId,
    required Json categoryJson
  }) async {
    return await _database.updateCategory(
      categoryId,
      categoryJson
    );
  }

  @override
  Future<void> deleteCategory({ required int categoryId }) async {
    return await _database.deleteCategory(categoryId);
  }
}