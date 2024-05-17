import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/books/domain/entities/author_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/category_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/publisher_entity.dart';

class BookEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? isbn10;
  final String? isbn13;
  final int? edition;
  final DateTime? publishDate;
  final PublisherEntity publisher;
  final List<AuthorEntity> authors;
  final List<CategoryEntity> categories;
  final bool? bought;

  const BookEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.isbn10,
    this.isbn13,
    this.edition,
    this.publishDate,
    required this.publisher,
    required this.authors,
    required this.categories,
    this.bought
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    title,
    isbn10,
    isbn13,
    edition,
    publishDate,
    publisher,
    authors,
    categories,
    bought
  ];
}