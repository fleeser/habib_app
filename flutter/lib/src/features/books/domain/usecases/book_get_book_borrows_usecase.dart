import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';
import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'book_get_book_borrows_usecase.g.dart';

@riverpod
BookGetBookBorrowsUsecase bookGetBookBorrowsUsecase(BookGetBookBorrowsUsecaseRef ref) {
  return BookGetBookBorrowsUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookGetBookBorrowsUsecase extends UsecaseWithParams<List<BookBorrowEntity>, BookGetBookBorrowsUsecaseParams> {

  final BookRepository _bookRepository;

  const BookGetBookBorrowsUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<List<BookBorrowEntity>> call(BookGetBookBorrowsUsecaseParams params) async {
    return await _bookRepository.getBookBorrows(
      bookId: params.bookId,
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class BookGetBookBorrowsUsecaseParams extends Equatable {

  final int bookId;
  final String searchText;
  final int currentPage;

  const BookGetBookBorrowsUsecaseParams({ 
    required this.bookId,
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    bookId,
    searchText,
    currentPage
  ];
}