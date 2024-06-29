import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';

class CategoryDto extends CategoryEntity {

  const CategoryDto({
    required super.id,
    required super.name
  });

  factory CategoryDto.fromJson(Json categoryJson) {
    return CategoryDto(
      id: categoryJson['category_id'] as int,
      name: categoryJson['category_name'] as String
    );
  }

  static List<CategoryDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CategoryDto.fromJson(json)).toList();
  }
}