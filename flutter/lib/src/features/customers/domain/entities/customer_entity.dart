import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/customers/domain/entities/address_entity.dart';

class CustomerEntity extends Equatable {

  final int id;
  final String firstName;
  final String lastName;
  final String? title;
  final String? phone;
  final String? mobile;
  final AddressEntity address;

  const CustomerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.title,
    this.phone,
    this.mobile,
    required this.address
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    title,
    phone,
    mobile,
    address
  ];
}