import 'package:equatable/equatable.dart';

class BorrowCustomerEntity extends Equatable {

  final int id;
  final String firstName;
  final String lastName;
  final String? title;

  const BorrowCustomerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.title
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    title
  ];
}