import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_get_books_usecase.dart';

part 'books_page_notifier.g.dart';

enum BooksPageStatus {
  initial,
  loading,
  success,
  failure
}

class BooksPageState extends Equatable {
  
  final BooksPageStatus status;
  final Exception? exception;
  final List<BookEntity> books;
  final bool hasReachedEnd;
  final int currentPage;

  const BooksPageState({
    this.status = BooksPageStatus.initial,
    this.exception,
    this.books = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  BooksPageState copyWith({
    BooksPageStatus? status,
    Exception? exception,
    List<BookEntity>? books,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeException = false,
    bool removeBooks = false
  }) {
    return BooksPageState(
      status: status ?? this.status,
      exception: removeException ? null : exception ?? this.exception,
      books: removeBooks ? [] : books ?? this.books,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    books,
    hasReachedEnd,
    currentPage
  ];
}

@riverpod
class BooksPageNotifier extends _$BooksPageNotifier {

  late BookGetBooksUsecase _bookGetBooksUsecase;

  @override
  BooksPageState build() {
    _bookGetBooksUsecase = ref.read(bookGetBooksUsecaseProvider);
    return const BooksPageState();
  }

  Future<void> fetchNextPage() async {
    if (state.status == BooksPageStatus.loading) return;
    if (state.hasReachedEnd) return;

    state = state.copyWith(
      status: BooksPageStatus.loading,
      removeException: true
    );

    final BookGetBooksUsecaseParams params = BookGetBooksUsecaseParams(currentPage: state.currentPage);
    final Result<List<BookEntity>> result = await _bookGetBooksUsecase.call(params);
    
    result.fold(
      onSuccess: (List<BookEntity> books) {
        state = state.copyWith(
          status: BooksPageStatus.success,
          currentPage: books.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          books: List.of(state.books)..addAll(books),
          hasReachedEnd: books.length < NetworkConstants.pageSize,
          removeException: true
        );
      }, 
      onFailure: (Exception exception, StackTrace stackTrace) {
        state = state.copyWith(
          status: BooksPageStatus.failure,
          exception: exception
        );
      }
    );
  }
}