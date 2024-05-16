import 'package:equatable/equatable.dart';

class PublisherEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String? city;

  const PublisherEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.city
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    name,
    city
  ];
}