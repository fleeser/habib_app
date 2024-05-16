import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_dto.dart';

class BorrowDatasourceImpl implements BorrowDatasource {

  final Database _database;

  const BorrowDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<BorrowDto>> getBorrows({ required int currentPage }) async {
    final List<Json> jsonList = await _database.getBorrows(currentPage: currentPage);
    return BorrowDto.listFromJsonList(jsonList);
  }
}