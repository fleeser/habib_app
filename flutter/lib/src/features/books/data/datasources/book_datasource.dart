import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/data/dto/book_details_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_borrow_dto.dart';
import 'package:habib_app/core/utils/typedefs.dart';
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

  Future<List<BookDto>> getBooks({ required String searchText, required int currentPage });

  Future<List<BookBorrowDto>> getBookBorrows({ required int bookId, required String searchText, required int currentPage });

  Future<BookDetailsDto> getBook({ required int bookId });

  Future<int> createBook({
    required Json bookJson,
    required List<int> authorIds,
    required List<int> categoryIds,
    required List<int> publisherIds
  });

  Future<void> updateBook({
    required int bookId,
    required Json bookJson,
    required List<int> removeAuthorIds,
    required List<int> addAuthorIds,
    required List<int> removeCategoryIds,
    required List<int> addCategoryIds,
    required List<int> removePublisherIds,
    required List<int> addPublisherIds
  });

  Future<void> deleteBook({ required int bookId });
}