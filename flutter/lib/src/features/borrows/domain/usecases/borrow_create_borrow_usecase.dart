import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_create_borrow_usecase.g.dart';

@riverpod
BorrowCreateBorrowUsecase borrowCreateBorrowUsecase(BorrowCreateBorrowUsecaseRef ref) {
  return BorrowCreateBorrowUsecase(
    borrowRepository: ref.read(borrowRepositoryProvider)
  );
}

class BorrowCreateBorrowUsecase extends UsecaseWithParams<int, BorrowCreateBorrowUsecaseParams> {

  final BorrowRepository _borrowRepository;

  const BorrowCreateBorrowUsecase({
    required BorrowRepository borrowRepository
  })  : _borrowRepository = borrowRepository;

  @override
  ResultFuture<int> call(BorrowCreateBorrowUsecaseParams params) async {
    return await _borrowRepository.createBorrow(
      borrowJson: params.borrowJson
    );
  }
}

class BorrowCreateBorrowUsecaseParams extends Equatable {

  final Json borrowJson;

  const BorrowCreateBorrowUsecaseParams({ 
    required this.borrowJson
  });

  @override
  List<Object?> get props => [
    borrowJson
  ];
}