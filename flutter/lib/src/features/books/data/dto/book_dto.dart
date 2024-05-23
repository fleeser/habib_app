import 'dart:convert';

import 'package:habib_app/core/extensions/generic_extension.dart';
import 'package:habib_app/core/utils/enums/book_status.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/dto/book_author_dto.dart';
import 'package:habib_app/src/features/books/data/dto/book_category_dto.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';

class BookDto extends BookEntity {

  const BookDto({
    required super.id,
    required super.title,
    super.isbn10,
    super.isbn13,
    super.edition,
    super.authors,
    super.categories,
    required super.status
  });

  factory BookDto.fromJson(Json bookJson) {
    return BookDto(
      id: bookJson['book_id'] as int,
      title: bookJson['book_title'] as String,
      isbn10: bookJson['book_isbn_10'] as String?,
      isbn13: bookJson['book_isbn_13'] as String?,
      edition: bookJson['book_edition'] as int?,
      authors: (bookJson['authors'] as String?).whenNotNull<List<BookAuthorDto>>((String authorsJson) => List<Json>.from(json.decode(authorsJson)).map<BookAuthorDto>((Json authorJson) => BookAuthorDto.fromJson(authorJson)).toList()),
      categories: (bookJson['categories'] as String?).whenNotNull<List<BookCategoryDto>>((String categoriesJson) => List<Json>.from(json.decode(categoriesJson)).map<BookCategoryDto>((Json categoryJson) => BookCategoryDto.fromJson(categoryJson)).toList()),
      status: BookStatus.fromDatabaseValue(bookJson['book_status'] as int)
    );
  }

  static List<BookDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookDto.fromJson(json)).toList();
  }
}