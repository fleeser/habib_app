import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';
import 'package:habib_app/src/features/authors/domain/usecases/author_get_authors_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'authors_page_notifier.g.dart';

@riverpod
class AuthorsPageNotifier extends _$AuthorsPageNotifier {

  late AuthorGetAuthorsUsecase _authorGetAuthorsUsecase;

  @override
  AuthorsPageState build() {
    _authorGetAuthorsUsecase = ref.read(authorGetAuthorsUsecaseProvider);
    return const AuthorsPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isAuthorsLoading: true,
      removeError: true
    );

    final AuthorGetAuthorsUsecaseParams params = AuthorGetAuthorsUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<AuthorEntity>> result = await _authorGetAuthorsUsecase.call(params);
    
    result.fold(
      onSuccess: (List<AuthorEntity> authors) {
        state = state.copyWith(
          isAuthorsLoading: false,
          currentPage: authors.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          authors: List.of(state.authors)..addAll(authors),
          hasReachedEnd: authors.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isAuthorsLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const AuthorsPageState();
    await fetchNextPage(searchText);
  }
}

class AuthorsPageState extends Equatable {

  final bool isAuthorsLoading;
  final ErrorDetails? error;
  final List<AuthorEntity> authors;
  final bool hasReachedEnd;
  final int currentPage;

  const AuthorsPageState({
    this.isAuthorsLoading = false,
    this.error,
    this.authors = const <AuthorEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isAuthorsLoading;
  bool get hasAuthors => authors.isNotEmpty;

  AuthorsPageState copyWith({
    bool? isAuthorsLoading = false,
    ErrorDetails? error,
    List<AuthorEntity>? authors,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeAuthors = false
  }) {
    return AuthorsPageState(
      isAuthorsLoading: isAuthorsLoading ?? this.isAuthorsLoading,
      error: removeError ? null : error ?? this.error,
      authors: removeAuthors ? const <AuthorEntity>[] : authors ?? this.authors,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isAuthorsLoading,
    error,
    authors,
    hasReachedEnd,
    currentPage
  ];
}