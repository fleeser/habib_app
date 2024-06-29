import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/domain/usecases/borrow_get_borrows_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'borrows_page_notifier.g.dart';

@riverpod
class BorrowsPageNotifier extends _$BorrowsPageNotifier {

  late BorrowGetBorrowsUsecase _borrowGetBorrowsUsecase;

  @override
  BorrowsPageState build() {
    _borrowGetBorrowsUsecase = ref.read(borrowGetBorrowsUsecaseProvider);
    return const BorrowsPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isBorrowsLoading: true,
      removeError: true
    );

    final BorrowGetBorrowsUsecaseParams params = BorrowGetBorrowsUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<BorrowEntity>> result = await _borrowGetBorrowsUsecase.call(params);
    
    result.fold(
      onSuccess: (List<BorrowEntity> borrows) {
        state = state.copyWith(
          isBorrowsLoading: false,
          currentPage: borrows.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          borrows: List.of(state.borrows)..addAll(borrows),
          hasReachedEnd: borrows.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isBorrowsLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const BorrowsPageState();
    await fetchNextPage(searchText);
  }
}

class BorrowsPageState extends Equatable {

  final bool isBorrowsLoading;
  final ErrorDetails? error;
  final List<BorrowEntity> borrows;
  final bool hasReachedEnd;
  final int currentPage;

  const BorrowsPageState({
    this.isBorrowsLoading = false,
    this.error,
    this.borrows = const <BorrowEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isBorrowsLoading;
  bool get hasBorrows => borrows.isNotEmpty;

  BorrowsPageState copyWith({
    bool? isBorrowsLoading = false,
    ErrorDetails? error,
    List<BorrowEntity>? borrows,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeBorrows = false
  }) {
    return BorrowsPageState(
      isBorrowsLoading: isBorrowsLoading ?? this.isBorrowsLoading,
      error: removeError ? null : error ?? this.error,
      borrows: removeBorrows ? const <BorrowEntity>[] : borrows ?? this.borrows,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isBorrowsLoading,
    error,
    borrows,
    hasReachedEnd,
    currentPage
  ];
}