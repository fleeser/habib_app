import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';

part 'book_get_books_usecase.g.dart';

@riverpod
BookGetBooksUsecase bookGetBooksUsecase(BookGetBooksUsecaseRef ref) {
  return BookGetBooksUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookGetBooksUsecase extends UsecaseWithParams<List<BookEntity>, BookGetBooksUsecaseParams> {

  final BookRepository _bookRepository;

  const BookGetBooksUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<List<BookEntity>> call(BookGetBooksUsecaseParams params) async {
    return await _bookRepository.getBooks(
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class BookGetBooksUsecaseParams extends Equatable {

  final String searchText;
  final int currentPage;

  const BookGetBooksUsecaseParams({ 
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    searchText,
    currentPage
  ];
}