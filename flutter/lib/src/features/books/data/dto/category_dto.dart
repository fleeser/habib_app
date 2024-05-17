import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/category_entity.dart';

class CategoryDto extends CategoryEntity {

  const CategoryDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.name
  });

  factory CategoryDto.fromJson(Json json) {
    return CategoryDto(
      id: json['category_id'] as int,
      createdAt: json['category_created_at'] as DateTime,
      updatedAt: json['category_updated_at'] as DateTime, 
      name: json['category_name'] as String
    );
  }

  static List<CategoryDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CategoryDto.fromJson(json)).toList();
  }
}