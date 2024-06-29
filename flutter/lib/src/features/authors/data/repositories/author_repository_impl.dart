import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/authors/data/datasources/author_datasource.dart';
import 'package:habib_app/src/features/authors/data/dto/author_details_dto.dart';
import 'package:habib_app/src/features/authors/data/dto/author_dto.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';
import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';

class AuthorRepositoryImpl implements AuthorRepository {

  final AuthorDatasource _authorDatasource;

  const AuthorRepositoryImpl({
    required AuthorDatasource authorDatasource
  })  : _authorDatasource = authorDatasource;

  @override
  ResultFuture<List<AuthorEntity>> getAuthors({ required String searchText, required int currentPage }) async {
    try {
      final List<AuthorDto> result = await _authorDatasource.getAuthors(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createAuthor({
    required Json authorJson
  }) async {
    try {
      final int authorId = await _authorDatasource.createAuthor(authorJson: authorJson);
      return Success(authorId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<AuthorDetailsEntity> getAuthor({ required int authorId }) async {
    try {
      final AuthorDetailsDto result = await _authorDatasource.getAuthor(authorId: authorId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updateAuthor({
    required int authorId,
    required Json authorJson
  }) async {
    try {
      await _authorDatasource.updateAuthor(
        authorId: authorId,
        authorJson: authorJson
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deleteAuthor({ required int authorId }) async {
    try {
      await _authorDatasource.deleteAuthor(authorId: authorId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}