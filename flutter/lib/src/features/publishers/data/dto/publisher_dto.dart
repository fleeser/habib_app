import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';

class PublisherDto extends PublisherEntity {

  const PublisherDto({
    required super.id,
    required super.name,
    super.city
  });

  factory PublisherDto.fromJson(Json publisherJson) {
    return PublisherDto(
      id: publisherJson['publisher_id'] as int,
      name: publisherJson['publisher_name'] as String,
      city: publisherJson['publisher_title'] as String?
    );
  }

  static List<PublisherDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => PublisherDto.fromJson(json)).toList();
  }
}