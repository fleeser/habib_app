import 'package:equatable/equatable.dart';

class AuthorDetailsEntity extends Equatable {

  final int id;
  final String? title;
  final String firstName;
  final String lastName;

  const AuthorDetailsEntity({
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