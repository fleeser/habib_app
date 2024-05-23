import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource_impl.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_dto.dart';

part 'borrow_datasource.g.dart';

@riverpod
BorrowDatasource borrowDatasource(BorrowDatasourceRef ref) {
  return BorrowDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class BorrowDatasource {

  const BorrowDatasource();

  Future<List<BorrowDto>> getBorrows({ required String searchText, required int currentPage });
}