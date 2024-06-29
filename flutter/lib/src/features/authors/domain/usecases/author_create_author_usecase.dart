import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_create_author_usecase.g.dart';

@riverpod
AuthorCreateAuthorUsecase authorCreateAuthorUsecase(AuthorCreateAuthorUsecaseRef ref) {
  return AuthorCreateAuthorUsecase(
    authorRepository: ref.read(authorRepositoryProvider)
  );
}

class AuthorCreateAuthorUsecase extends UsecaseWithParams<int, AuthorCreateAuthorUsecaseParams> {

  final AuthorRepository _authorRepository;

  const AuthorCreateAuthorUsecase({
    required AuthorRepository authorRepository
  })  : _authorRepository = authorRepository;

  @override
  ResultFuture<int> call(AuthorCreateAuthorUsecaseParams params) async {
    return await _authorRepository.createAuthor(authorJson: params.authorJson);
  }
}

class AuthorCreateAuthorUsecaseParams extends Equatable {

  final Json authorJson;

  const AuthorCreateAuthorUsecaseParams({ 
    required this.authorJson
  });

  @override
  List<Object?> get props => [
    authorJson
  ];
}