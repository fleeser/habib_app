import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/data/repositories/borrow_repository_impl.dart';
import 'package:habib_app/src/features/borrows/data/datasources/borrow_datasource.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'borrow_repository.g.dart';

@riverpod
BorrowRepository borrowRepository(BorrowRepositoryRef ref) {
  return BorrowRepositoryImpl(
    borrowDatasource: ref.read(borrowDatasourceProvider)
  );
}

abstract interface class BorrowRepository {

  ResultFuture<List<BorrowEntity>> getBorrows({ required String searchText, required int currentPage });
}