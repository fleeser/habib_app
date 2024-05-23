import 'package:equatable/equatable.dart';

import 'package:habib_app/core/utils/enums/book_status.dart';
import 'package:habib_app/src/features/books/domain/entities/author_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/category_entity.dart';

class BookEntity extends Equatable {

  final int id;
  final String title;
  final String? isbn10;
  final String? isbn13;
  final int? edition;
  final List<AuthorEntity>? authors;
  final List<CategoryEntity>? categories;
  final BookStatus status;

  const BookEntity({
    required this.id,
    required this.title,
    this.isbn10,
    this.isbn13,
    this.edition,
    this.authors,
    this.categories,
    required this.status
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isbn10,
    isbn13,
    edition,
    authors,
    categories,
    status
  ];
}