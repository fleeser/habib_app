import 'package:equatable/equatable.dart';

class PublisherEntity extends Equatable {

  final int id;
  final String name;
  final String? city;

  const PublisherEntity({
    required this.id,
    required this.name,
    this.city
  });

  @override
  List<Object?> get props => [
    id,
    name,
    city
  ];
}