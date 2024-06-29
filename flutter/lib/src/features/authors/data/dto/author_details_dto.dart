import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';

class AuthorDetailsDto extends AuthorDetailsEntity {

  const AuthorDetailsDto({
    required super.id,
    super.title,
    required super.firstName,
    required super.lastName
  });

  factory AuthorDetailsDto.fromJson(Json authorJson) {
    return AuthorDetailsDto(
      id: authorJson['author_id'] as int,
      title: authorJson['author_title'] as String?,
      firstName: authorJson['author_first_name'] as String,
      lastName: authorJson['author_last_name'] as String
    );
  }
}