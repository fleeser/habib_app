import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/src/features/categories/domain/usecases/category_get_categories_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'categories_page_notifier.g.dart';

@riverpod
class CategoriesPageNotifier extends _$CategoriesPageNotifier {

  late CategoryGetCategoriesUsecase _categoryGetCategoriesUsecase;

  @override
  CategoriesPageState build() {
    _categoryGetCategoriesUsecase = ref.read(categoryGetCategoriesUsecaseProvider);
    return const CategoriesPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isCategoriesLoading: true,
      removeError: true
    );

    final CategoryGetCategoriesUsecaseParams params = CategoryGetCategoriesUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<CategoryEntity>> result = await _categoryGetCategoriesUsecase.call(params);
    
    result.fold(
      onSuccess: (List<CategoryEntity> categories) {
        state = state.copyWith(
          isCategoriesLoading: false,
          currentPage: categories.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          categories: List.of(state.categories)..addAll(categories),
          hasReachedEnd: categories.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isCategoriesLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const CategoriesPageState();
    await fetchNextPage(searchText);
  }
}

class CategoriesPageState extends Equatable {

  final bool isCategoriesLoading;
  final ErrorDetails? error;
  final List<CategoryEntity> categories;
  final bool hasReachedEnd;
  final int currentPage;

  const CategoriesPageState({
    this.isCategoriesLoading = false,
    this.error,
    this.categories = const <CategoryEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isCategoriesLoading;
  bool get hasCategories => categories.isNotEmpty;

  CategoriesPageState copyWith({
    bool? isCategoriesLoading = false,
    ErrorDetails? error,
    List<CategoryEntity>? categories,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeCategories = false
  }) {
    return CategoriesPageState(
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      error: removeError ? null : error ?? this.error,
      categories: removeCategories ? const <CategoryEntity>[] : categories ?? this.categories,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isCategoriesLoading,
    error,
    categories,
    hasReachedEnd,
    currentPage
  ];
}