import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/usecases/borrow_get_borrows_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';

part 'borrows_page_notifier.g.dart';

enum BorrowsPageStatus {
  initial,
  loading,
  success,
  failure
}

class BorrowsPageState extends Equatable {
  
  final BorrowsPageStatus status;
  final Exception? exception;
  final List<BorrowEntity> borrows;
  final bool hasReachedEnd;
  final int currentPage;

  const BorrowsPageState({
    this.status = BorrowsPageStatus.initial,
    this.exception,
    this.borrows = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  BorrowsPageState copyWith({
    BorrowsPageStatus? status,
    Exception? exception,
    List<BorrowEntity>? borrows,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeException = false,
    bool removeBorrows = false
  }) {
    return BorrowsPageState(
      status: status ?? this.status,
      exception: removeException ? null : exception ?? this.exception,
      borrows: removeBorrows ? [] : borrows ?? this.borrows,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    borrows,
    hasReachedEnd,
    currentPage
  ];
}

@riverpod
class BorrowsPageNotifier extends _$BorrowsPageNotifier {

  late BorrowGetBorrowsUsecase _borrowGetBorrowsUsecase;

  @override
  BorrowsPageState build() {
    _borrowGetBorrowsUsecase = ref.read(borrowGetBorrowsUsecaseProvider);
    return const BorrowsPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.status == BorrowsPageStatus.loading) return;
    if (state.hasReachedEnd) return;

    state = state.copyWith(
      status: BorrowsPageStatus.loading,
      removeException: true
    );

    final BorrowGetBorrowsUsecaseParams params = BorrowGetBorrowsUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<BorrowEntity>> result = await _borrowGetBorrowsUsecase.call(params);
    
    result.fold(
      onSuccess: (List<BorrowEntity> borrows) {
        state = state.copyWith(
          status: BorrowsPageStatus.success,
          currentPage: borrows.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          borrows: List.of(state.borrows)..addAll(borrows),
          hasReachedEnd: borrows.length < NetworkConstants.pageSize,
          removeException: true
        );
      }, 
      onFailure: (Exception exception, StackTrace stackTrace) {
        state = state.copyWith(
          status: BorrowsPageStatus.failure,
          exception: exception
        );
      }
    );
  }

  Future<void> refresh(String searchText) async {
    state = const BorrowsPageState();
    await fetchNextPage(searchText);
  }
}