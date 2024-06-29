import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/repositories/book_repository_impl.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';

part 'book_repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepositoryImpl(
    bookDatasource: ref.read(bookDatasourceProvider)
  );
}

abstract interface class BookRepository {

  ResultFuture<List<BookEntity>> getBooks({ required String searchText, required int currentPage });

  ResultFuture<List<BookBorrowEntity>> getBookBorrows({ required int bookId, required String searchText, required int currentPage });

  ResultFuture<BookDetailsEntity> getBook({ required int bookId });

  ResultFuture<int> createBook({
    required Json bookJson,
    required List<int> authorIds,
    required List<int> categoryIds,
    required List<int> publisherIds
  });

  ResultFuture<void> updateBook({
    required int bookId,
    required Json bookJson,
    required List<int> removeAuthorIds,
    required List<int> addAuthorIds,
    required List<int> removeCategoryIds,
    required List<int> addCategoryIds,
    required List<int> removePublisherIds,
    required List<int> addPublisherIds
  });

  ResultFuture<void> deleteBook({ required int bookId });
}