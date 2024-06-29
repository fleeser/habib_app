import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_details_address_entity.dart';

class CustomerDetailsEntity extends Equatable {

  final int id;
  final String firstName;
  final String lastName;
  final String? occupation;
  final String? title;
  final String? phone;
  final String? mobile;
  final CustomerDetailsAddressEntity address;

  const CustomerDetailsEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.occupation,
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
    occupation,
    title,
    phone,
    mobile,
    address
  ];
}