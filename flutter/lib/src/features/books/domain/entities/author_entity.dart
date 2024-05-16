import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String firstName;
  final String lastName;
  final String? title;

  const AuthorEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    this.title
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    firstName,
    lastName,
    title
  ];
}