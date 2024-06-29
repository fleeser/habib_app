import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_category_entity.dart';

class BookDetailsCategoryDto extends BookDetailsCategoryEntity {

  const BookDetailsCategoryDto({
    required super.id,
    required super.name
  });

  factory BookDetailsCategoryDto.fromJson(Json categoryJson) {
    return BookDetailsCategoryDto(
      id: categoryJson['category_id'] as int,
      name: categoryJson['category_name'] as String
    );
  }
}