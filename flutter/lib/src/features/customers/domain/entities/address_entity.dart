import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {

  final int id;
  final String city;
  final String postalCode;
  final String street;

  const AddressEntity({
    required this.id,
    required this.city,
    required this.postalCode,
    required this.street
  });

  @override
  List<Object?> get props => [
    id,
    city,
    postalCode,
    street
  ];
}