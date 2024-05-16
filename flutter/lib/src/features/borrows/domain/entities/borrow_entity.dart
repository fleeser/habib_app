import 'package:equatable/equatable.dart';

import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';

enum BorrowStatus {

  borrowed('borrowed'),
  returned('returned'),
  exceeded('exceeded'),
  warned('warned');

  final String databaseValue;

  const BorrowStatus(
    this.databaseValue
  );

  static BorrowStatus fromDatabaseString(String databaseString) {
    return BorrowStatus.values.firstWhere((BorrowStatus borrowStatus) 
        => borrowStatus.databaseValue == databaseString);
  }
}

class BorrowEntity extends Equatable {

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BookEntity? book;
  final CustomerEntity? customer;
  final DateTime endDate;
  final BorrowStatus? status;

  const BorrowEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.book,
    this.customer,
    required this.endDate,
    this.status
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    book,
    customer,
    endDate,
    status
  ];
}