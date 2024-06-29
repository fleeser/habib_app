import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/repositories/category_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'category_create_category_usecase.g.dart';

@riverpod
CategoryCreateCategoryUsecase categoryCreateCategoryUsecase(CategoryCreateCategoryUsecaseRef ref) {
  return CategoryCreateCategoryUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider)
  );
}

class CategoryCreateCategoryUsecase extends UsecaseWithParams<int, CategoryCreateCategoryUsecaseParams> {

  final CategoryRepository _categoryRepository;

  const CategoryCreateCategoryUsecase({
    required CategoryRepository categoryRepository
  })  : _categoryRepository = categoryRepository;

  @override
  ResultFuture<int> call(CategoryCreateCategoryUsecaseParams params) async {
    return await _categoryRepository.createCategory(categoryJson: params.categoryJson);
  }
}

class CategoryCreateCategoryUsecaseParams extends Equatable {

  final Json categoryJson;

  const CategoryCreateCategoryUsecaseParams({ 
    required this.categoryJson
  });

  @override
  List<Object?> get props => [
    categoryJson
  ];
}