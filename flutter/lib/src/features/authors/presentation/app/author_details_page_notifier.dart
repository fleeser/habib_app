import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';
import 'package:habib_app/src/features/authors/presentation/app/author_get_author_usecase.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/utils/result.dart';

part 'author_details_page_notifier.g.dart';

@riverpod
class AuthorDetailsPageNotifier extends _$AuthorDetailsPageNotifier {

  late AuthorGetAuthorUsecase _authorGetAuthorUsecase;

  @override
  AuthorDetailsPageState build(int authorId) {
    _authorGetAuthorUsecase = ref.read(authorGetAuthorUsecaseProvider);
    return const AuthorDetailsPageState();
  }

  void replace(AuthorDetailsEntity author) {
    state = state.copyWith(author: author);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isAuthorLoading: true,
      removeError: true
    );

    final AuthorGetAuthorUsecaseParams authorParams = AuthorGetAuthorUsecaseParams(authorId: authorId);
    final Result<AuthorDetailsEntity> result = await _authorGetAuthorUsecase.call(authorParams);
    
    result.fold(
      onSuccess: (AuthorDetailsEntity author) {
        state = state.copyWith(
          isAuthorLoading: false,
          author: author
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isAuthorLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class AuthorDetailsPageState extends Equatable {

  final bool isAuthorLoading;
  final ErrorDetails? error;
  final AuthorDetailsEntity? author;

  const AuthorDetailsPageState({
    this.isAuthorLoading = false,
    this.error,
    this.author
  });

  bool get hasError => error != null;
  bool get isLoading => isAuthorLoading;
  bool get hasAuthor => author != null;

  AuthorDetailsPageState copyWith({
    bool? isAuthorLoading = false,
    ErrorDetails? error,
    AuthorDetailsEntity? author,
    bool removeError = false,
    bool removeAuthor = false
  }) {
    return AuthorDetailsPageState(
      isAuthorLoading: isAuthorLoading ?? this.isAuthorLoading,
      error: removeError ? null : error ?? this.error,
      author: removeAuthor ? null : author ?? this.author
    );
  }

  @override
  List<Object?> get props => [
    isAuthorLoading,
    error,
    author
  ];
}