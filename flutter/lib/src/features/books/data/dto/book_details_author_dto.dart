import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_author_entity.dart';

class BookDetailsAuthorDto extends BookDetailsAuthorEntity {

  const BookDetailsAuthorDto({
    required super.id,
    super.title,
    required super.firstName,
    required super.lastName
  });

  factory BookDetailsAuthorDto.fromJson(Json authorJson) {
    return BookDetailsAuthorDto(
      id: authorJson['author_id'] as int,
      title: authorJson['author_title'] as String?,
      firstName: authorJson['author_first_name'] as String,
      lastName: authorJson['author_last_name'] as String
    );
  }
}