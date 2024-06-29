import 'package:equatable/equatable.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_get_book_usecase.dart';
import 'package:habib_app/core/utils/result.dart';

part 'book_details_page_notifier.g.dart';

@riverpod
class BookDetailsPageNotifier extends _$BookDetailsPageNotifier {

  late BookGetBookUsecase _bookGetBookUsecase;

  @override
  BookDetailsPageState build(int bookId) {
    _bookGetBookUsecase = ref.read(bookGetBookUsecaseProvider);
    return const BookDetailsPageState();
  }

  void replace(BookDetailsEntity book) {
    state = state.copyWith(book: book);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isBookLoading: true,
      removeError: true
    );

    final BookGetBookUsecaseParams bookParams = BookGetBookUsecaseParams(bookId: bookId);
    final Result<BookDetailsEntity> result = await _bookGetBookUsecase.call(bookParams);
    
    result.fold(
      onSuccess: (BookDetailsEntity book) {
        state = state.copyWith(
          isBookLoading: false,
          book: book
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isBookLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class BookDetailsPageState extends Equatable {

  final bool isBookLoading;
  final ErrorDetails? error;
  final BookDetailsEntity? book;

  const BookDetailsPageState({
    this.isBookLoading = false,
    this.error,
    this.book
  });

  bool get hasError => error != null;
  bool get isLoading => isBookLoading;
  bool get hasBook => book != null;

  BookDetailsPageState copyWith({
    bool? isBookLoading = false,
    ErrorDetails? error,
    BookDetailsEntity? book,
    bool removeError = false,
    bool removeBook = false
  }) {
    return BookDetailsPageState(
      isBookLoading: isBookLoading ?? this.isBookLoading,
      error: removeError ? null : error ?? this.error,
      book: removeBook ? null : book ?? this.book
    );
  }

  @override
  List<Object?> get props => [
    isBookLoading,
    error,
    book
  ];
}