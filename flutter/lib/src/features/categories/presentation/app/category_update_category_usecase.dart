import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_update_category_usecase.g.dart';

@riverpod
CategoryUpdateCategoryUsecase categoryUpdateCategoryUsecase(CategoryUpdateCategoryUsecaseRef ref) {
  return CategoryUpdateCategoryUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider)
  );
}

class CategoryUpdateCategoryUsecase extends UsecaseWithParams<void, CategoryUpdateCategoryUsecaseParams> {

  final CategoryRepository _categoryRepository;

  const CategoryUpdateCategoryUsecase({
    required CategoryRepository categoryRepository
  })  : _categoryRepository = categoryRepository;

  @override
  ResultFuture<void> call(CategoryUpdateCategoryUsecaseParams params) async {
    return await _categoryRepository.updateCategory(
      categoryId: params.categoryId,
      categoryJson: params.categoryJson
    );
  }
}

class CategoryUpdateCategoryUsecaseParams extends Equatable {

  final int categoryId;
  final Json categoryJson;

  const CategoryUpdateCategoryUsecaseParams({ 
    required this.categoryId,
    required this.categoryJson
  });

  @override
  List<Object?> get props => [
    categoryId,
    categoryJson
  ];
}