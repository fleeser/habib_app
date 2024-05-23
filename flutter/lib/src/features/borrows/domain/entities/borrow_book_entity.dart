import 'package:equatable/equatable.dart';

class BorrowBookEntity extends Equatable {

  final int id;
  final String title;
  final int? edition;

  const BorrowBookEntity({
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