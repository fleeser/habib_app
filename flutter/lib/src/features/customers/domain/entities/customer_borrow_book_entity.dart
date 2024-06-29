import 'package:equatable/equatable.dart';

class CustomerBorrowBookEntity extends Equatable {

  final int id;
  final String title;
  final int? edition;

  const CustomerBorrowBookEntity({
    required this.id,
    required this.title,
    this.edition
  });

  @override
  List<Object?> get props => [
    id,
    title,
    edition
  ];
}