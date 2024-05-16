import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/entities/address_entity.dart';

class AddressDto extends AddressEntity {

  const AddressDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.city,
    required super.postalCode,
    required super.street
  });

  factory AddressDto.fromJson(Json json) {
    return AddressDto(
      id: json['id'] as int, 
      createdAt: json['address_created_at'] as DateTime, 
      updatedAt: json['address_updated_at'] as DateTime,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      street: json['street'] as String
    );
  }
}