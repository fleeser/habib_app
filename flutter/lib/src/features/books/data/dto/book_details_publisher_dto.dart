import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_publisher_entity.dart';

class BookDetailsPublisherDto extends BookDetailsPublisherEntity {

  const BookDetailsPublisherDto({
    required super.id,
    required super.name,
    super.city
  });

  factory BookDetailsPublisherDto.fromJson(Json publisherJson) {
    return BookDetailsPublisherDto(
      id: publisherJson['publisher_id'] as int,
      name: publisherJson['publisher_name'] as String,
      city: publisherJson['publisher_city'] as String?
    );
  }
}