import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';
import 'package:habib_app/src/features/authors/data/datasources/author_datasource.dart';
import 'package:habib_app/src/features/authors/data/repositories/author_repository_impl.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_repository.g.dart';

@riverpod
AuthorRepository authorRepository(AuthorRepositoryRef ref) {
  return AuthorRepositoryImpl(
    authorDatasource: ref.read(authorDatasourceProvider)
  );
}

abstract interface class AuthorRepository {

  ResultFuture<List<AuthorEntity>> getAuthors({ required String searchText, required int currentPage });

  ResultFuture<int> createAuthor({
    required Json authorJson
  });

  ResultFuture<AuthorDetailsEntity> getAuthor({ required int authorId });

  ResultFuture<void> updateAuthor({
    required int authorId,
    required Json authorJson
  });

  ResultFuture<void> deleteAuthor({ required int authorId });
}