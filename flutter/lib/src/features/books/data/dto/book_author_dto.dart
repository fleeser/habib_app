import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_author_entity.dart';

class BookAuthorDto extends BookAuthorEntity {

  const BookAuthorDto({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.title
  });

  factory BookAuthorDto.fromJson(Json authorJson) {
    return BookAuthorDto(
      id: authorJson['author_id'] as int,
      firstName: authorJson['author_first_name'] as String,
      lastName: authorJson['author_last_name'] as String,
      title: authorJson['author_title'] as String?
    );
  }

  static List<BookAuthorDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookAuthorDto.fromJson(json)).toList();
  }
}