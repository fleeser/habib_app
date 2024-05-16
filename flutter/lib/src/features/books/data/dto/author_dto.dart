import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/author_entity.dart';

class AuthorDto extends AuthorEntity {

  const AuthorDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.firstName,
    required super.lastName,
    super.title
  });

  factory AuthorDto.fromJson(Json json) {
    return AuthorDto(
      id: json['author_id'] as int,
      createdAt: json['author_created_at'] as DateTime,
      updatedAt: json['author_updated_at'] as DateTime, 
      firstName: json['author_first_name'] as String,
      lastName: json['author_last_name'] as String,
      title: json['author_title'] as String?
    );
  }
}