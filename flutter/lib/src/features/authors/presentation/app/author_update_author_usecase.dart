import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_update_author_usecase.g.dart';

@riverpod
AuthorUpdateAuthorUsecase authorUpdateAuthorUsecase(AuthorUpdateAuthorUsecaseRef ref) {
  return AuthorUpdateAuthorUsecase(
    authorRepository: ref.read(authorRepositoryProvider)
  );
}

class AuthorUpdateAuthorUsecase extends UsecaseWithParams<void, AuthorUpdateAuthorUsecaseParams> {

  final AuthorRepository _authorRepository;

  const AuthorUpdateAuthorUsecase({
    required AuthorRepository authorRepository
  })  : _authorRepository = authorRepository;

  @override
  ResultFuture<void> call(AuthorUpdateAuthorUsecaseParams params) async {
    return await _authorRepository.updateAuthor(
      authorId: params.authorId,
      authorJson: params.authorJson
    );
  }
}

class AuthorUpdateAuthorUsecaseParams extends Equatable {

  final int authorId;
  final Json authorJson;

  const AuthorUpdateAuthorUsecaseParams({ 
    required this.authorId,
    required this.authorJson
  });

  @override
  List<Object?> get props => [
    authorId,
    authorJson
  ];
}