import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/data/dto/author_details_dto.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/authors/data/datasources/author_datasource_impl.dart';
import 'package:habib_app/src/features/authors/data/dto/author_dto.dart';
import 'package:habib_app/core/services/database.dart';

part 'author_datasource.g.dart';

@riverpod
AuthorDatasource authorDatasource(AuthorDatasourceRef ref) {
  return AuthorDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class AuthorDatasource {

  const AuthorDatasource();

  Future<List<AuthorDto>> getAuthors({ required String searchText, required int currentPage });

  Future<int> createAuthor({
    required Json authorJson
  });

  Future<AuthorDetailsDto> getAuthor({ required int authorId });

  Future<void> updateAuthor({
    required int authorId,
    required Json authorJson
  });

  Future<void> deleteAuthor({ required int authorId });
}