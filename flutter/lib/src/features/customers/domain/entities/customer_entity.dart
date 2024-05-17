import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/customers/domain/entities/address_entity.dart';

class CustomerEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String firstName;
  final String lastName;
  final String? title;
  final String? occupation;
  final String? phone;
  final String? mobile;
  final AddressEntity address;

  const CustomerEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    this.title,
    this.occupation,
    this.phone,
    this.mobile,
    required this.address
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    firstName,
    lastName,
    title,
    occupation,
    phone,
    mobile,
    address
  ];
}