import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource.dart';
import 'package:habib_app/src/features/books/data/dto/book_dto.dart';
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
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}