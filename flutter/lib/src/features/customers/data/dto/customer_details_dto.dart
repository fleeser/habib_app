import 'dart:convert';

import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_details_address_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';

class CustomerDetailsDto extends CustomerDetailsEntity {

  const CustomerDetailsDto({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.occupation,
    super.title,
    super.phone,
    super.mobile,
    required super.address
  });

  factory CustomerDetailsDto.fromJson(Json customerJson) {
    return CustomerDetailsDto(
      id: customerJson['customer_id'] as int,
      firstName: customerJson['customer_first_name'] as String,
      lastName: customerJson['customer_last_name'] as String,
      occupation: customerJson['customer_occupation'] as String?,
      title: customerJson['customer_title'] as String?,
      phone: customerJson['customer_phone'] as String?,
      mobile: customerJson['customer_mobile'] as String?,
      address: CustomerDetailsAddressDto.fromJson(json.decode(customerJson['address'] as String))
    );
  }
}