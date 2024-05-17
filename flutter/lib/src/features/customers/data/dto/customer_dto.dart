import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/dto/address_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';

class CustomerDto extends CustomerEntity {

  const CustomerDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.firstName,
    required super.lastName,
    super.title,
    super.occupation,
    super.phone,
    super.mobile,
    required super.address
  });

  factory CustomerDto.fromJson(Json json) {
    return CustomerDto(
      id: json['id'] as int, 
      createdAt: json['customer_created_at'] as DateTime,
      updatedAt: json['customer_updated_at'] as DateTime,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      title: json['title'] as String?,
      occupation: json['occupation'] as String?,
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      address: AddressDto.fromJson(json)
    );
  }

  static List<CustomerDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CustomerDto.fromJson(json)).toList();
  }
}