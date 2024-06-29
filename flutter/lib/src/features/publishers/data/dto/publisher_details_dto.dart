import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';

class PublisherDetailsDto extends PublisherDetailsEntity {

  const PublisherDetailsDto({
    required super.id,
    required super.name,
    super.city
  });

  factory PublisherDetailsDto.fromJson(Json publisherJson) {
    return PublisherDetailsDto(
      id: publisherJson['publisher_id'] as int,
      name: publisherJson['publisher_name'] as String,
      city: publisherJson['publisher_city'] as String?
    );
  }
}