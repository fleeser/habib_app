import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';

class CustomerDto extends CustomerEntity {

  const CustomerDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.name
  });

  factory CustomerDto.fromJson(Json json) {
    return CustomerDto(
      id: json['id'] as int, 
      createdAt: json['created_at'] as DateTime, 
      updatedAt: json['updated_at'] as DateTime, 
      name: json['name'] as String
    );
  }

  static List<CustomerDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CustomerDto.fromJson(json)).toList();
  }
}