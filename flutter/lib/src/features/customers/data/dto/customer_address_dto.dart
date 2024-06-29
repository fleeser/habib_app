import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_address_entity.dart';

class CustomerAddressDto extends CustomerAddressEntity {

  const CustomerAddressDto({
    required super.id,
    required super.street,
    required super.city,
    required super.postalCode
  });

  factory CustomerAddressDto.fromJson(Json addressJson) {
    return CustomerAddressDto(
      id: addressJson['address_id'] as int,
      city: addressJson['address_city'] as String,
      postalCode: addressJson['address_postal_code'] as String,
      street: addressJson['address_street'] as String
    );
  }
}