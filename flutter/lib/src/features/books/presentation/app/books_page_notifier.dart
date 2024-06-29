import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_get_books_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'books_page_notifier.g.dart';

@riverpod
class BooksPageNotifier extends _$BooksPageNotifier {

  late BookGetBooksUsecase _bookGetBooksUsecase;

  @override
  BooksPageState build() {
    _bookGetBooksUsecase = ref.read(bookGetBooksUsecaseProvider);
    return const BooksPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isBooksLoading: true,
      removeError: true
    );

    final BookGetBooksUsecaseParams params = BookGetBooksUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<BookEntity>> result = await _bookGetBooksUsecase.call(params);
    
    result.fold(
      onSuccess: (List<BookEntity> books) {
        state = state.copyWith(
          isBooksLoading: false,
          currentPage: books.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          books: List.of(state.books)..addAll(books),
          hasReachedEnd: books.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isBooksLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const BooksPageState();
    await fetchNextPage(searchText);
  }
}

class BooksPageState extends Equatable {

  final bool isBooksLoading;
  final ErrorDetails? error;
  final List<BookEntity> books;
  final bool hasReachedEnd;
  final int currentPage;

  const BooksPageState({
    this.isBooksLoading = false,
    this.error,
    this.books = const <BookEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isBooksLoading;
  bool get hasBooks => books.isNotEmpty;

  BooksPageState copyWith({
    bool? isBooksLoading = false,
    ErrorDetails? error,
    List<BookEntity>? books,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeBooks = false
  }) {
    return BooksPageState(
      isBooksLoading: isBooksLoading ?? this.isBooksLoading,
      error: removeError ? null : error ?? this.error,
      books: removeBooks ? const <BookEntity>[] : books ?? this.books,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isBooksLoading,
    error,
    books,
    hasReachedEnd,
    currentPage
  ];
}