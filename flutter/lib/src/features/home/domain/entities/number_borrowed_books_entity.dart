import 'package:equatable/equatable.dart';

class NumberBorrowedBooksEntity extends Equatable {

  final int month;
  final int booksCount;

  const NumberBorrowedBooksEntity({
    required this.month,
    required this.booksCount
  });

  @override
  List<Object?> get props => [
    month,
    booksCount
  ];
}