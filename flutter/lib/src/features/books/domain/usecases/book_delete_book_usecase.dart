import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'book_delete_book_usecase.g.dart';

@riverpod
BookDeleteBookUsecase bookDeleteBookUsecase(BookDeleteBookUsecaseRef ref) {
  return BookDeleteBookUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookDeleteBookUsecase extends UsecaseWithParams<void, BookDeleteBookUsecaseParams> {

  final BookRepository _bookRepository;

  const BookDeleteBookUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<void> call(BookDeleteBookUsecaseParams params) async {
    return await _bookRepository.deleteBook(bookId: params.bookId);
  }
}

class BookDeleteBookUsecaseParams extends Equatable {

  final int bookId;

  const BookDeleteBookUsecaseParams({ required this.bookId });

  @override
  List<Object?> get props => [
    bookId
  ];
}