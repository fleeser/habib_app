import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_get_borrows_usecase.g.dart';

@riverpod
BorrowGetBorrowsUsecase borrowGetBorrowsUsecase(BorrowGetBorrowsUsecaseRef ref) {
  return BorrowGetBorrowsUsecase(
    borrowRepository: ref.read(borrowRepositoryProvider)
  );
}

class BorrowGetBorrowsUsecase extends UsecaseWithParams<List<BorrowEntity>, BorrowGetBorrowsUsecaseParams> {

  final BorrowRepository _borrowRepository;

  const BorrowGetBorrowsUsecase({
    required BorrowRepository borrowRepository
  })  : _borrowRepository = borrowRepository;

  @override
  ResultFuture<List<BorrowEntity>> call(BorrowGetBorrowsUsecaseParams params) async {
    return await _borrowRepository.getBorrows(currentPage: params.currentPage);
  }
}

class BorrowGetBorrowsUsecaseParams extends Equatable {

  final int currentPage;

  const BorrowGetBorrowsUsecaseParams({ required this.currentPage });

  @override
  List<Object?> get props => [
    currentPage
  ];
}