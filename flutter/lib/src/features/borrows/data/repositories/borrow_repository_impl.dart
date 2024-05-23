import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_dto.dart';
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
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}