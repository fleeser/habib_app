import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource.dart';
import 'package:habib_app/src/features/books/data/dto/book_borrow_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_details_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_dto.dart';

class BookDatasourceImpl implements BookDatasource {

  final Database _database;

  const BookDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<BookDto>> getBooks({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getBooks(
      searchText: searchText,
      currentPage: currentPage
    );
    return BookDto.listFromJsonList(jsonList);
  }

  @override
  Future<List<BookBorrowDto>> getBookBorrows({ required int bookId, required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getBookBorrows(
      bookId: bookId,
      searchText: searchText, 
      currentPage: currentPage
    );
    return BookBorrowDto.listFromJsonList(jsonList);
  }

  @override
  Future<BookDetailsDto> getBook({ required int bookId }) async {
    final Json json = await _database.getBook(bookId: bookId);
    return BookDetailsDto.fromJson(json);
  }

  @override
  Future<int> createBook({
    required Json bookJson,
    required List<int> authorIds,
    required List<int> categoryIds,
    required List<int> publisherIds
  }) async {
    return await _database.createBook(
      bookJson: bookJson,
      authorIds: authorIds,
      categoryIds: categoryIds,
      publisherIds: publisherIds
    );
  }

  @override
  Future<void> updateBook({
    required int bookId,
    required Json bookJson,
    required List<int> removeAuthorIds,
    required List<int> addAuthorIds,
    required List<int> removeCategoryIds,
    required List<int> addCategoryIds,
    required List<int> removePublisherIds,
    required List<int> addPublisherIds
  }) async {
    return await _database.updateBook(
      bookId: bookId,
      bookJson: bookJson,
      removeAuthorIds: removeAuthorIds,
      addAuthorIds: addAuthorIds,
      removeCategoryIds: removeCategoryIds,
      addCategoryIds: addCategoryIds,
      removePublisherIds: removePublisherIds,
      addPublisherIds: addPublisherIds
    );
  }

  @override
  Future<void> deleteBook({ required int bookId }) async {
    return await _database.deleteBook(bookId);
  }
}