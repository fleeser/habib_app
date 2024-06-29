import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/authors/domain/repositories/author_repository.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'author_get_authors_usecase.g.dart';

@riverpod
AuthorGetAuthorsUsecase authorGetAuthorsUsecase(AuthorGetAuthorsUsecaseRef ref) {
  return AuthorGetAuthorsUsecase(
    authorRepository: ref.read(authorRepositoryProvider)
  );
}

class AuthorGetAuthorsUsecase extends UsecaseWithParams<List<AuthorEntity>, AuthorGetAuthorsUsecaseParams> {

  final AuthorRepository _authorRepository;

  const AuthorGetAuthorsUsecase({
    required AuthorRepository authorRepository
  })  : _authorRepository = authorRepository;

  @override
  ResultFuture<List<AuthorEntity>> call(AuthorGetAuthorsUsecaseParams params) async {
    return await _authorRepository.getAuthors(
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class AuthorGetAuthorsUsecaseParams extends Equatable {

  final String searchText;
  final int currentPage;

  const AuthorGetAuthorsUsecaseParams({ 
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    searchText,
    currentPage
  ];
}