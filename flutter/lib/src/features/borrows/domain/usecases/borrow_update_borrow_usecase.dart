import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_update_borrow_usecase.g.dart';

@riverpod
BorrowUpdateBorrowUsecase borrowUpdateBorrowUsecase(BorrowUpdateBorrowUsecaseRef ref) {
  return BorrowUpdateBorrowUsecase(
    borrowRepository: ref.read(borrowRepositoryProvider)
  );
}

class BorrowUpdateBorrowUsecase extends UsecaseWithParams<void, BorrowUpdateBorrowUsecaseParams> {

  final BorrowRepository _borrowRepository;

  const BorrowUpdateBorrowUsecase({
    required BorrowRepository borrowRepository
  })  : _borrowRepository = borrowRepository;

  @override
  ResultFuture<void> call(BorrowUpdateBorrowUsecaseParams params) async {
    return await _borrowRepository.updateBorrow(
      borrowId: params.borrowId,
      borrowJson: params.borrowJson
    );
  }
}

class BorrowUpdateBorrowUsecaseParams extends Equatable {

  final int borrowId;
  final Json borrowJson;

  const BorrowUpdateBorrowUsecaseParams({ 
    required this.borrowId,
    required this.borrowJson
  });

  @override
  List<Object?> get props => [
    borrowId,
    borrowJson
  ];
}