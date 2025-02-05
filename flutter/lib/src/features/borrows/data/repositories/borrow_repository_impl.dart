import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_details_dto.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_dto.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_entity.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/domain/repositories/borrow_repository.dart';

class BorrowRepositoryImpl implements BorrowRepository {

  final BorrowDatasource _borrowDatasource;

  const BorrowRepositoryImpl({
    required BorrowDatasource borrowDatasource
  })  : _borrowDatasource = borrowDatasource;

  @override
  ResultFuture<List<BorrowEntity>> getBorrows({ required String searchText, required int currentPage }) async {
    try {
      final List<BorrowDto> result = await _borrowDatasource.getBorrows(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<BorrowDetailsEntity> getBorrow({ required int borrowId }) async {
    try {
      final BorrowDetailsDto result = await _borrowDatasource.getBorrow(borrowId: borrowId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createBorrow({
    required Json borrowJson
  }) async {
    try {
      final int borrowId = await _borrowDatasource.createBorrow(
        borrowJson: borrowJson
      );
      return Success(borrowId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updateBorrow({
    required int borrowId,
    required Json borrowJson
  }) async {
    try {
      await _borrowDatasource.updateBorrow(
        borrowId: borrowId,
        borrowJson: borrowJson
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deleteBorrow({ required int borrowId }) async {
    try {
      await _borrowDatasource.deleteBorrow(borrowId: borrowId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}