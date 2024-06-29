import 'package:equatable/equatable.dart';

class BookDetailsPublisherEntity extends Equatable {

  final int id;
  final String name;
  final String? city;

  const BookDetailsPublisherEntity({
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