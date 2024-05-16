import 'package:habib_app/core/extensions/generic_extension.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/dto/author_dto.dart';
import 'package:habib_app/src/features/books/data/dto/publisher_dto.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';

class BookDto extends BookEntity {

  const BookDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.title,
    super.isbn10,
    super.isbn13,
    super.edition,
    super.publishDate,
    super.publisher,
    super.author,
    super.bought
  });

  factory BookDto.fromJson(Json json) {
    return BookDto(
      id: json['book_id'] as int, 
      createdAt: json['book_created_at'] as DateTime, 
      updatedAt: json['book_updated_at'] as DateTime, 
      title: json['book_title'] as String,
      isbn10: json['book_isbn_10'] as String?,
      isbn13: json['book_isbn_13'] as String?,
      edition: json['book_edition'] as int?,
      publishDate: json['book_publish_date'] as DateTime?,
      publisher: (json['publisher_id'] as int?).whenNotNull<PublisherDto>((int _) => PublisherDto.fromJson(json)),
      author: (json['author_id'] as int?).whenNotNull<AuthorDto>((int _) => AuthorDto.fromJson(json)),
      bought: (json['bought'] as int?).whenNotNull<bool>((int databaseBought) => databaseBought == 1)
    );
  }

  static List<BookDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookDto.fromJson(json)).toList();
  }
}