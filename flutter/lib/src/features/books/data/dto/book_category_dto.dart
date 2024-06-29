import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_category_entity.dart';

class BookCategoryDto extends BookCategoryEntity {

  const BookCategoryDto({
    required super.id,
    required super.name
  });

  factory BookCategoryDto.fromJson(Json categoryJson) {
    return BookCategoryDto(
      id: categoryJson['category_id'] as int, 
      name: categoryJson['category_name'] as String
    );
  }

  static List<BookCategoryDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookCategoryDto.fromJson(json)).toList();
  }
}