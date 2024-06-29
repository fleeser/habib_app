import 'package:equatable/equatable.dart';

class BookCategoryEntity extends Equatable {

  final int id;
  final String name;

  const BookCategoryEntity({
    required this.id,
    required this.name
  });

  @override
  List<Object?> get props => [
    id,
    name
  ];
}