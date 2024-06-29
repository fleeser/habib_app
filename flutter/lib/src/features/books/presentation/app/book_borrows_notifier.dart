import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_get_book_borrows_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'book_borrows_notifier.g.dart';

@riverpod
class BookBorrowsNotifier extends _$BookBorrowsNotifier {

  late BookGetBookBorrowsUsecase _bookGetBookBorrowsUsecase;

  @override
  BookBorrowsState build(int bookId) {
    _bookGetBookBorrowsUsecase = ref.read(bookGetBookBorrowsUsecaseProvider);
    return const BookBorrowsState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isBookBorrowsLoading: true,
      removeError: true
    );

    final BookGetBookBorrowsUsecaseParams params = BookGetBookBorrowsUsecaseParams(
      bookId: bookId,
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<BookBorrowEntity>> result = await _bookGetBookBorrowsUsecase.call(params);
    
    result.fold(
      onSuccess: (List<BookBorrowEntity> bookBorrows) {
        state = state.copyWith(
          isBookBorrowsLoading: false,
          currentPage: bookBorrows.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          bookBorrows: List.of(state.bookBorrows)..addAll(bookBorrows),
          hasReachedEnd: bookBorrows.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isBookBorrowsLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const BookBorrowsState();
    await fetchNextPage(searchText);
  }
}

class BookBorrowsState extends Equatable {

  final bool isBookBorrowsLoading;
  final ErrorDetails? error;
  final List<BookBorrowEntity> bookBorrows;
  final bool hasReachedEnd;
  final int currentPage;

  const BookBorrowsState({
    this.isBookBorrowsLoading = false,
    this.error,
    this.bookBorrows = const <BookBorrowEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isBookBorrowsLoading;
  bool get hasBooksBorrows => bookBorrows.isNotEmpty;

  BookBorrowsState copyWith({
    bool? isBookBorrowsLoading = false,
    ErrorDetails? error,
    List<BookBorrowEntity>? bookBorrows,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeBookBorrows = false
  }) {
    return BookBorrowsState(
      isBookBorrowsLoading: isBookBorrowsLoading ?? this.isBookBorrowsLoading,
      error: removeError ? null : error ?? this.error,
      bookBorrows: removeBookBorrows ? const <BookBorrowEntity>[] : bookBorrows ?? this.bookBorrows,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isBookBorrowsLoading,
    error,
    bookBorrows,
    hasReachedEnd,
    currentPage
  ];
}