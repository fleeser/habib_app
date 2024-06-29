import 'package:equatable/equatable.dart';

class BookDetailsAuthorEntity extends Equatable {

  final int id;
  final String? title;
  final String firstName;
  final String lastName;

  const BookDetailsAuthorEntity({
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