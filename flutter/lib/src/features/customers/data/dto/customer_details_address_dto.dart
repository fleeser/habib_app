import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_details_address_entity.dart';

class CustomerDetailsAddressDto extends CustomerDetailsAddressEntity {

  const CustomerDetailsAddressDto({
    required super.id,
    required super.street,
    required super.city,
    required super.postalCode
  });

  factory CustomerDetailsAddressDto.fromJson(Json addressJson) {
    return CustomerDetailsAddressDto(
      id: addressJson['address_id'] as int,
      city: addressJson['address_city'] as String,
      postalCode: addressJson['address_postal_code'] as String,
      street: addressJson['address_street'] as String
    );
  }
}