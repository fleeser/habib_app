import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_details_dto.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_dto.dart';

class BorrowDatasourceImpl implements BorrowDatasource {

  final Database _database;

  const BorrowDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<BorrowDto>> getBorrows({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getBorrows(
      searchText: searchText,
      currentPage: currentPage
    );
    return BorrowDto.listFromJsonList(jsonList);
  }

  @override
  Future<BorrowDetailsDto> getBorrow({ required int borrowId }) async {
    final Json json = await _database.getBorrow(borrowId: borrowId);
    return BorrowDetailsDto.fromJson(json);
  }

  @override
  Future<int> createBorrow({
    required Json borrowJson
  }) async {
    return await _database.createBorrow(
      borrowJson: borrowJson
    );
  }

  @override
  Future<void> updateBorrow({
    required int borrowId,
    required Json borrowJson
  }) async {
    return await _database.updateBorrow(
      borrowId,
      borrowJson
    );
  }

  @override
  Future<void> deleteBorrow({ required int borrowId }) async {
    return await _database.deleteBorrow(borrowId);
  }
}