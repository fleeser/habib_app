import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';
import 'package:habib_app/src/features/categories/presentation/app/category_get_category_usecase.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/utils/result.dart';

part 'category_details_page_notifier.g.dart';

@riverpod
class CategoryDetailsPageNotifier extends _$CategoryDetailsPageNotifier {

  late CategoryGetCategoryUsecase _categoryGetCategoryUsecase;

  @override
  CategoryDetailsPageState build(int categoryId) {
    _categoryGetCategoryUsecase = ref.read(categoryGetCategoryUsecaseProvider);
    return const CategoryDetailsPageState();
  }

  void replace(CategoryDetailsEntity category) {
    state = state.copyWith(category: category);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isCategoryLoading: true,
      removeError: true
    );

    final CategoryGetCategoryUsecaseParams categoryParams = CategoryGetCategoryUsecaseParams(categoryId: categoryId);
    final Result<CategoryDetailsEntity> result = await _categoryGetCategoryUsecase.call(categoryParams);
    
    result.fold(
      onSuccess: (CategoryDetailsEntity category) {
        state = state.copyWith(
          isCategoryLoading: false,
          category: category
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isCategoryLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class CategoryDetailsPageState extends Equatable {

  final bool isCategoryLoading;
  final ErrorDetails? error;
  final CategoryDetailsEntity? category;

  const CategoryDetailsPageState({
    this.isCategoryLoading = false,
    this.error,
    this.category
  });

  bool get hasError => error != null;
  bool get isLoading => isCategoryLoading;
  bool get hasCategory => category != null;

  CategoryDetailsPageState copyWith({
    bool? isCategoryLoading = false,
    ErrorDetails? error,
    CategoryDetailsEntity? category,
    bool removeError = false,
    bool removeCategory = false
  }) {
    return CategoryDetailsPageState(
      isCategoryLoading: isCategoryLoading ?? this.isCategoryLoading,
      error: removeError ? null : error ?? this.error,
      category: removeCategory ? null : category ?? this.category
    );
  }

  @override
  List<Object?> get props => [
    isCategoryLoading,
    error,
    category
  ];
}