import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';
import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_get_author_usecase.g.dart';

@riverpod
AuthorGetAuthorUsecase authorGetAuthorUsecase(AuthorGetAuthorUsecaseRef ref) {
  return AuthorGetAuthorUsecase(
    authorRepository: ref.read(authorRepositoryProvider)
  );
}

class AuthorGetAuthorUsecase extends UsecaseWithParams<AuthorDetailsEntity, AuthorGetAuthorUsecaseParams> {

  final AuthorRepository _authorRepository;

  const AuthorGetAuthorUsecase({
    required AuthorRepository authorRepository
  })  : _authorRepository = authorRepository;

  @override
  ResultFuture<AuthorDetailsEntity> call(AuthorGetAuthorUsecaseParams params) async {
    return await _authorRepository.getAuthor(authorId: params.authorId);
  }
}

class AuthorGetAuthorUsecaseParams extends Equatable {

  final int authorId;

  const AuthorGetAuthorUsecaseParams({ required this.authorId });

  @override
  List<Object?> get props => [
    authorId
  ];
}