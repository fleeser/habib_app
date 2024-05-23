import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/books/data/datasources/book_datasource.dart';
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
}