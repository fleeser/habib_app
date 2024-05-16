import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;

  const CategoryEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    name
  ];
}