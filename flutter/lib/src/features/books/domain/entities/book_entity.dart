import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? isbn10;
  final String? isbn13;

  const BookEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.isbn10,
    this.isbn13
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    title,
    isbn10,
    isbn13
  ];
}