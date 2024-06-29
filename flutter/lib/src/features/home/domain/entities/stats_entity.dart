import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/home/domain/entities/new_books_bought_entity.dart';
import 'package:habib_app/src/features/home/domain/entities/number_borrowed_books_entity.dart';

class StatsEntity extends Equatable {

  final List<NumberBorrowedBooksEntity> numberBorrowedBooksList;
  final List<NewBooksBoughtEntity> newBooksBoughtList;

  const StatsEntity({
    required this.numberBorrowedBooksList,
    required this.newBooksBoughtList
  });

  @override
  List<Object?> get props => [
    numberBorrowedBooksList,
    newBooksBoughtList
  ];
}