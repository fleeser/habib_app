import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/books/domain/entities/book_details_author_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_category_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_publisher_entity.dart';

class BookDetailsEntity extends Equatable {

  final int id;
  final String title;
  final String? isbn10;
  final String? isbn13;
  final int? edition;
  final DateTime? publishDate;
  final bool? bought;
  final DateTime receivedAt;
  final List<BookDetailsAuthorEntity> authors;
  final List<BookDetailsCategoryEntity> categories;
  final List<BookDetailsPublisherEntity> publishers;

  const BookDetailsEntity({
    required this.id,
    required this.title,
    this.isbn10,
    this.isbn13,
    this.edition,
    this.publishDate,
    this.bought,
    required this.receivedAt,
    required this.authors,
    required this.categories,
    required this.publishers
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isbn10,
    isbn13,
    edition,
    publishDate,
    bought,
    receivedAt
  ];
}