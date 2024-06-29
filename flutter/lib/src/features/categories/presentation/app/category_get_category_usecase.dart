import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';
import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_get_category_usecase.g.dart';

@riverpod
CategoryGetCategoryUsecase categoryGetCategoryUsecase(CategoryGetCategoryUsecaseRef ref) {
  return CategoryGetCategoryUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider)
  );
}

class CategoryGetCategoryUsecase extends UsecaseWithParams<CategoryDetailsEntity, CategoryGetCategoryUsecaseParams> {

  final CategoryRepository _categoryRepository;

  const CategoryGetCategoryUsecase({
    required CategoryRepository categoryRepository
  })  : _categoryRepository = categoryRepository;

  @override
  ResultFuture<CategoryDetailsEntity> call(CategoryGetCategoryUsecaseParams params) async {
    return await _categoryRepository.getCategory(categoryId: params.categoryId);
  }
}

class CategoryGetCategoryUsecaseParams extends Equatable {

  final int categoryId;

  const CategoryGetCategoryUsecaseParams({ required this.categoryId });

  @override
  List<Object?> get props => [
    categoryId
  ];
}