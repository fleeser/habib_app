import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {

  final int id;
  final String name;

  const CategoryEntity({
    required this.id,
    required this.name
  });

  @override
  List<Object?> get props => [
    id,
    name
  ];
}