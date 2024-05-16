import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/publisher_entity.dart';

class PublisherDto extends PublisherEntity {

  const PublisherDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.name,
    super.city
  });

  factory PublisherDto.fromJson(Json json) {
    return PublisherDto(
      id: json['publisher_id'] as int,
      createdAt: json['publisher_created_at'] as DateTime,
      updatedAt: json['publisher_updated_at'] as DateTime,
      name: json['publisher_name'] as String,
      city: json['publisher_city'] as String?
    );
  }
}