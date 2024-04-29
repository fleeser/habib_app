import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource_impl.dart';
import 'package:habib_app/src/features/books/data/dto/book_dto.dart';

part 'book_datasource.g.dart';

@riverpod
BookDatasource bookDatasource(BookDatasourceRef ref) {
  return BookDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class BookDatasource {

  const BookDatasource();

  Future<List<BookDto>> getBooks({ required int currentPage });
}