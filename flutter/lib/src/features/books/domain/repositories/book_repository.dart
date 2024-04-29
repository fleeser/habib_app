import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  ResultFuture<List<BookEntity>> getBooks({ required int currentPage });
}