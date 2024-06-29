import 'package:equatable/equatable.dart';

class BookBorrowCustomerEntity extends Equatable {

  final int id;
  final String? title;
  final String firstName;
  final String lastName;

  const BookBorrowCustomerEntity({
    required this.id,
    this.title,
    required this.firstName,
    required this.lastName
  });

  @override
  List<Object?> get props => [
    id,
    title,
    firstName,
    lastName
  ];
}