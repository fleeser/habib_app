import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/books/domain/repositories/book_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'book_update_book_usecase.g.dart';

@riverpod
BookUpdateBookUsecase bookUpdateBookUsecase(BookUpdateBookUsecaseRef ref) {
  return BookUpdateBookUsecase(
    bookRepository: ref.read(bookRepositoryProvider)
  );
}

class BookUpdateBookUsecase extends UsecaseWithParams<void, BookUpdateBookUsecaseParams> {

  final BookRepository _bookRepository;

  const BookUpdateBookUsecase({
    required BookRepository bookRepository
  })  : _bookRepository = bookRepository;

  @override
  ResultFuture<void> call(BookUpdateBookUsecaseParams params) async {
    return await _bookRepository.updateBook(
      bookId: params.bookId,
      bookJson: params.bookJson,
      removeAuthorIds: params.removeAuthorIds,
      addAuthorIds: params.addAuthorIds,
      removeCategoryIds: params.removeCategoryIds,
      addCategoryIds: params.addCategoryIds,
      removePublisherIds: params.removePublisherIds,
      addPublisherIds: params.addPublisherIds
    );
  }
}

class BookUpdateBookUsecaseParams extends Equatable {

  final int bookId;
  final Json bookJson;
  final List<int> removeAuthorIds;
  final List<int> addAuthorIds;
  final List<int> removeCategoryIds;
  final List<int> addCategoryIds;
  final List<int> removePublisherIds;
  final List<int> addPublisherIds;

  const BookUpdateBookUsecaseParams({ 
    required this.bookId,
    required this.bookJson,
    required this.removeAuthorIds,
    required this.addAuthorIds,
    required this.removeCategoryIds,
    required this.addCategoryIds,
    required this.removePublisherIds,
    required this.addPublisherIds
  });

  @override
  List<Object?> get props => [
    bookId,
    bookJson,
    removeAuthorIds,
    addAuthorIds,
    removeCategoryIds,
    addCategoryIds,
    removePublisherIds,
    addPublisherIds
  ];
}