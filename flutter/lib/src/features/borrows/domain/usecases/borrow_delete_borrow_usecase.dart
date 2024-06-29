import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_delete_borrow_usecase.g.dart';

@riverpod
BorrowDeleteBorrowUsecase borrowDeleteBorrowUsecase(BorrowDeleteBorrowUsecaseRef ref) {
  return BorrowDeleteBorrowUsecase(
    borrowRepository: ref.read(borrowRepositoryProvider)
  );
}

class BorrowDeleteBorrowUsecase extends UsecaseWithParams<void, BorrowDeleteBorrowUsecaseParams> {

  final BorrowRepository _borrowRepository;

  const BorrowDeleteBorrowUsecase({
    required BorrowRepository borrowRepository
  })  : _borrowRepository = borrowRepository;

  @override
  ResultFuture<void> call(BorrowDeleteBorrowUsecaseParams params) async {
    return await _borrowRepository.deleteBorrow(borrowId: params.borrowId);
  }
}

class BorrowDeleteBorrowUsecaseParams extends Equatable {

  final int borrowId;

  const BorrowDeleteBorrowUsecaseParams({ required this.borrowId });

  @override
  List<Object?> get props => [
    borrowId
  ];
}