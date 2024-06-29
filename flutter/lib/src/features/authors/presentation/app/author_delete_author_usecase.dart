import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_delete_author_usecase.g.dart';

@riverpod
AuthorDeleteAuthorUsecase authorDeleteAuthorUsecase(AuthorDeleteAuthorUsecaseRef ref) {
  return AuthorDeleteAuthorUsecase(
    authorRepository: ref.read(authorRepositoryProvider)
  );
}

class AuthorDeleteAuthorUsecase extends UsecaseWithParams<void, AuthorDeleteAuthorUsecaseParams> {

  final AuthorRepository _authorRepository;

  const AuthorDeleteAuthorUsecase({
    required AuthorRepository authorRepository
  })  : _authorRepository = authorRepository;

  @override
  ResultFuture<void> call(AuthorDeleteAuthorUsecaseParams params) async {
    return await _authorRepository.deleteAuthor(authorId: params.authorId);
  }
}

class AuthorDeleteAuthorUsecaseParams extends Equatable {

  final int authorId;

  const AuthorDeleteAuthorUsecaseParams({ required this.authorId });

  @override
  List<Object?> get props => [
    authorId
  ];
}