import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';
import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'book_get_book_usecase.g.dart';

@riverpod
BookGetBookUsecase bookGetBookUsecase(BookGetBookUsecaseRef ref) {
  return BookGetBookUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookGetBookUsecase extends UsecaseWithParams<BookDetailsEntity, BookGetBookUsecaseParams> {

  final BookRepository _bookRepository;

  const BookGetBookUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<BookDetailsEntity> call(BookGetBookUsecaseParams params) async {
    return await _bookRepository.getBook(bookId: params.bookId);
  }
}

class BookGetBookUsecaseParams extends Equatable {

  final int bookId;

  const BookGetBookUsecaseParams({ required this.bookId });

  @override
  List<Object?> get props => [
    bookId
  ];
}