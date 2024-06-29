import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_entity.dart';
import 'package:habib_app/src/features/borrows/domain/usecases/borrow_get_borrow_usecase.dart';
import 'package:habib_app/core/utils/result.dart';

part 'borrow_details_page_notifier.g.dart';

@riverpod
class BorrowDetailsPageNotifier extends _$BorrowDetailsPageNotifier {

  late BorrowGetBorrowUsecase _borrowGetBorrowUsecase;

  @override
  BorrowDetailsPageState build(int borrowId) {
    _borrowGetBorrowUsecase = ref.read(borrowGetBorrowUsecaseProvider);
    return const BorrowDetailsPageState();
  }

  void replace(BorrowDetailsEntity borrow) {
    state = state.copyWith(borrow: borrow);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isBorrowLoading: true,
      removeError: true
    );

    final BorrowGetBorrowUsecaseParams borrowParams = BorrowGetBorrowUsecaseParams(borrowId: borrowId);
    final Result<BorrowDetailsEntity> result = await _borrowGetBorrowUsecase.call(borrowParams);
    
    result.fold(
      onSuccess: (BorrowDetailsEntity borrow) {
        state = state.copyWith(
          isBorrowLoading: false,
          borrow: borrow
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isBorrowLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class BorrowDetailsPageState extends Equatable {

  final bool isBorrowLoading;
  final ErrorDetails? error;
  final BorrowDetailsEntity? borrow;

  const BorrowDetailsPageState({
    this.isBorrowLoading = false,
    this.error,
    this.borrow
  });

  bool get hasError => error != null;
  bool get isLoading => isBorrowLoading;
  bool get hasBorrow => borrow != null;

  BorrowDetailsPageState copyWith({
    bool? isBorrowLoading = false,
    ErrorDetails? error,
    BorrowDetailsEntity? borrow,
    bool removeError = false,
    bool removeBorrow = false
  }) {
    return BorrowDetailsPageState(
      isBorrowLoading: isBorrowLoading ?? this.isBorrowLoading,
      error: removeError ? null : error ?? this.error,
      borrow: removeBorrow ? null : borrow ?? this.borrow
    );
  }

  @override
  List<Object?> get props => [
    isBorrowLoading,
    error,
    borrow
  ];
}