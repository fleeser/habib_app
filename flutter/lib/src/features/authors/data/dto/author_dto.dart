import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';

class AuthorDto extends AuthorEntity {

  const AuthorDto({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.title
  });

  factory AuthorDto.fromJson(Json authorJson) {
    return AuthorDto(
      id: authorJson['author_id'] as int,
      firstName: authorJson['author_first_name'] as String,
      lastName: authorJson['author_last_name'] as String,
      title: authorJson['author_title'] as String?
    );
  }

  static List<AuthorDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => AuthorDto.fromJson(json)).toList();
  }
}