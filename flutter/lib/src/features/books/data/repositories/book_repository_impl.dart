import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource.dart';
import 'package:habib_app/src/features/books/data/dto/book_borrow_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_details_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_dto.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {

  final BookDatasource _bookDatasource;

  const BookRepositoryImpl({
    required BookDatasource bookDatasource
  })  : _bookDatasource = bookDatasource;

  @override
  ResultFuture<List<BookEntity>> getBooks({ required String searchText, required int currentPage }) async {
    try {
      final List<BookDto> result = await _bookDatasource.getBooks(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<List<BookBorrowEntity>> getBookBorrows({ required int bookId, required String searchText, required int currentPage }) async {
    try {
      final List<BookBorrowDto> result = await _bookDatasource.getBookBorrows(
        bookId: bookId,
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<BookDetailsEntity> getBook({ required int bookId }) async {
    try {
      final BookDetailsDto result = await _bookDatasource.getBook(bookId: bookId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createBook({
    required Json bookJson,
    required List<int> authorIds,
    required List<int> categoryIds,
    required List<int> publisherIds
  }) async {
    try {
      final int bookId = await _bookDatasource.createBook(
        bookJson: bookJson,
        authorIds: authorIds,
        categoryIds: categoryIds,
        publisherIds: publisherIds
      );
      return Success(bookId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updateBook({
    required int bookId,
    required Json bookJson,
    required List<int> removeAuthorIds,
    required List<int> addAuthorIds,
    required List<int> removeCategoryIds,
    required List<int> addCategoryIds,
    required List<int> removePublisherIds,
    required List<int> addPublisherIds
  }) async {
    try {
      await _bookDatasource.updateBook(
        bookId: bookId,
        bookJson: bookJson,
        removeAuthorIds: removeAuthorIds,
        addAuthorIds: addAuthorIds,
        removeCategoryIds: removeCategoryIds,
        addCategoryIds: addCategoryIds,
        removePublisherIds: removePublisherIds,
        addPublisherIds: addPublisherIds
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deleteBook({ required int bookId }) async {
    try {
      await _bookDatasource.deleteBook(bookId: bookId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}