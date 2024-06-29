import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';

class CategoryDetailsDto extends CategoryDetailsEntity {

  const CategoryDetailsDto({
    required super.id,
    required super.name
  });

  factory CategoryDetailsDto.fromJson(Json categoryJson) {
    return CategoryDetailsDto(
      id: categoryJson['category_id'] as int,
      name: categoryJson['category_name'] as String
    );
  }
}