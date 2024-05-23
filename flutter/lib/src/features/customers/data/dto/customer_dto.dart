import 'dart:convert';

import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_address_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';

class CustomerDto extends CustomerEntity {

  const CustomerDto({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.title,
    super.phone,
    super.mobile,
    required super.address
  });

  factory CustomerDto.fromJson(Json customerJson) {
    return CustomerDto(
      id: customerJson['customer_id'] as int,
      firstName: customerJson['customer_first_name'] as String,
      lastName: customerJson['customer_last_name'] as String,
      title: customerJson['customer_title'] as String?,
      phone: customerJson['customer_phone'] as String?,
      mobile: customerJson['customer_mobile'] as String?,
      address: CustomerAddressDto.fromJson(json.decode(customerJson['address'] as String))
    );
  }

  static List<CustomerDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CustomerDto.fromJson(json)).toList();
  }
}