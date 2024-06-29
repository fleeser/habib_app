import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'book_create_book_usecase.g.dart';

@riverpod
BookCreateBookUsecase bookCreateBookUsecase(BookCreateBookUsecaseRef ref) {
  return BookCreateBookUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookCreateBookUsecase extends UsecaseWithParams<int, BookCreateBookUsecaseParams> {

  final BookRepository _bookRepository;

  const BookCreateBookUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<int> call(BookCreateBookUsecaseParams params) async {
    return await _bookRepository.createBook(
      bookJson: params.bookJson,
      authorIds: params.authorIds,
      categoryIds: params.categoryIds,
      publisherIds: params.publisherIds
    );
  }
}

class BookCreateBookUsecaseParams extends Equatable {

  final Json bookJson;
  final List<int> authorIds;
  final List<int> categoryIds;
  final List<int> publisherIds;

  const BookCreateBookUsecaseParams({ 
    required this.bookJson,
    required this.authorIds,
    required this.categoryIds,
    required this.publisherIds
  });

  @override
  List<Object?> get props => [
    bookJson,
    authorIds,
    categoryIds,
    publisherIds
  ];
}