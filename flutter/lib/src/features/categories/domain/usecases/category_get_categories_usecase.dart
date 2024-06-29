import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_get_categories_usecase.g.dart';

@riverpod
CategoryGetCategoriesUsecase categoryGetCategoriesUsecase(CategoryGetCategoriesUsecaseRef ref) {
  return CategoryGetCategoriesUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider)
  );
}

class CategoryGetCategoriesUsecase extends UsecaseWithParams<List<CategoryEntity>, CategoryGetCategoriesUsecaseParams> {

  final CategoryRepository _categoryRepository;

  const CategoryGetCategoriesUsecase({
    required CategoryRepository categoryRepository
  })  : _categoryRepository = categoryRepository;

  @override
  ResultFuture<List<CategoryEntity>> call(CategoryGetCategoriesUsecaseParams params) async {
    return await _categoryRepository.getCategories(
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class CategoryGetCategoriesUsecaseParams extends Equatable {

  final String searchText;
  final int currentPage;

  const CategoryGetCategoriesUsecaseParams({ 
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    searchText,
    currentPage
  ];
}