import 'package:equatable/equatable.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_entity.dart';
import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_get_borrow_usecase.g.dart';

@riverpod
BorrowGetBorrowUsecase borrowGetBorrowUsecase(BorrowGetBorrowUsecaseRef ref) {
  return BorrowGetBorrowUsecase(
    borrowRepository: ref.read(borrowRepositoryProvider)
  );
}

class BorrowGetBorrowUsecase extends UsecaseWithParams<BorrowDetailsEntity, BorrowGetBorrowUsecaseParams> {

  final BorrowRepository _borrowRepository;

  const BorrowGetBorrowUsecase({
    required BorrowRepository borrowRepository
  })  : _borrowRepository = borrowRepository;

  @override
  ResultFuture<BorrowDetailsEntity> call(BorrowGetBorrowUsecaseParams params) async {
    return await _borrowRepository.getBorrow(borrowId: params.borrowId);
  }
}

class BorrowGetBorrowUsecaseParams extends Equatable {

  final int borrowId;

  const BorrowGetBorrowUsecaseParams({ required this.borrowId });

  @override
  List<Object?> get props => [
    borrowId
  ];
}