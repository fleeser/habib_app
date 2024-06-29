import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_delete_category_usecase.g.dart';

@riverpod
CategoryDeleteCategoryUsecase categoryDeleteCategoryUsecase(CategoryDeleteCategoryUsecaseRef ref) {
  return CategoryDeleteCategoryUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider)
  );
}

class CategoryDeleteCategoryUsecase extends UsecaseWithParams<void, CategoryDeleteCategoryUsecaseParams> {

  final CategoryRepository _categoryRepository;

  const CategoryDeleteCategoryUsecase({
    required CategoryRepository categoryRepository
  })  : _categoryRepository = categoryRepository;

  @override
  ResultFuture<void> call(CategoryDeleteCategoryUsecaseParams params) async {
    return await _categoryRepository.deleteCategory(categoryId: params.categoryId);
  }
}

class CategoryDeleteCategoryUsecaseParams extends Equatable {

  final int categoryId;

  const CategoryDeleteCategoryUsecaseParams({ required this.categoryId });

  @override
  List<Object?> get props => [
    categoryId
  ];
}