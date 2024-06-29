import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/authors/data/datasources/author_datasource.dart';
import 'package:habib_app/src/features/authors/data/dto/author_details_dto.dart';
import 'package:habib_app/src/features/authors/data/dto/author_dto.dart';

class AuthorDatasourceImpl implements AuthorDatasource {

  final Database _database;

  const AuthorDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<AuthorDto>> getAuthors({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getAuthors(
      searchText: searchText, 
      currentPage: currentPage
    );
    return AuthorDto.listFromJsonList(jsonList);
  }

  @override
  Future<int> createAuthor({
    required Json authorJson
  }) async {
    return await _database.createAuthor(authorJson: authorJson);
  }

  @override
  Future<AuthorDetailsDto> getAuthor({ required int authorId }) async {
    final Json json = await _database.getAuthor(authorId: authorId);
    return AuthorDetailsDto.fromJson(json);
  }

  @override
  Future<void> updateAuthor({
    required int authorId,
    required Json authorJson
  }) async {
    return await _database.updateAuthor(
      authorId,
      authorJson
    );
  }

  @override
  Future<void> deleteAuthor({ required int authorId }) async {
    return await _database.deleteAuthor(authorId);
  }
}