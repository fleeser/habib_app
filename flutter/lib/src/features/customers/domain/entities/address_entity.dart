import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String city;
  final String postalCode;
  final String street;

  const AddressEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
    required this.postalCode,
    required this.street
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    city,
    postalCode,
    street
  ];
}