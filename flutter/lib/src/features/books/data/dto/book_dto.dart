import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';

class BookDto extends BookEntity {

  const BookDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.title,
    super.isbn10,
    super.isbn13
  });

  factory BookDto.fromJson(Json json) {
    return BookDto(
      id: json['id'] as int, 
      createdAt: json['created_at'] as DateTime, 
      updatedAt: json['updated_at'] as DateTime, 
      title: json['title'] as String,
      isbn10: json['isbn_10'] as String?,
      isbn13: json['isbn_13'] as String?
    );
  }

  static List<BookDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookDto.fromJson(json)).toList();
  }
}