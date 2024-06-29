import 'dart:convert';

import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/dto/book_details_author_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_details_category_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_details_publisher_dto.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';

class BookDetailsDto extends BookDetailsEntity {

  const BookDetailsDto({
    required super.id,
    required super.title,
    super.isbn10,
    super.isbn13,
    super.edition,
    super.publishDate,
    super.bought,
    required super.receivedAt,
    required super.authors,
    required super.categories,
    required super.publishers
  });

  factory BookDetailsDto.fromJson(Json bookJson) {
    return BookDetailsDto(
      id: bookJson['book_id'] as int,
      title: bookJson['book_title'] as String,
      isbn10: bookJson['book_isbn_10'] as String?,
      isbn13: bookJson['book_isbn_13'] as String?,
      edition: bookJson['book_edition'] as int?,
      publishDate: bookJson['book_publish_date'] as DateTime?,
      bought: (bookJson['book_bought'] as int?) == 1,
      receivedAt: bookJson['book_received_at'] as DateTime,
      authors: List<Json>.from(json.decode(bookJson['authors'] as String)).map<BookDetailsAuthorDto>((Json authorJson) => BookDetailsAuthorDto.fromJson(authorJson)).toList(),
      categories: List<Json>.from(json.decode(bookJson['categories'] as String)).map<BookDetailsCategoryDto>((Json categoryJson) => BookDetailsCategoryDto.fromJson(categoryJson)).toList(),
      publishers: List<Json>.from(json.decode(bookJson['publishers'] as String)).map<BookDetailsPublisherDto>((Json publisherJson) => BookDetailsPublisherDto.fromJson(publisherJson)).toList()
    );
  }
}

// TODO: From json wrft keinen sichtbaren fehler