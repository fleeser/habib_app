import 'package:equatable/equatable.dart';

class CategoryDetailsEntity extends Equatable {

  final int id;
  final String name;

  const CategoryDetailsEntity({
    required this.id,
    required this.name
  });

  @override
  List<Object?> get props => [
    id,
    name
  ];
}