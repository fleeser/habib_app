import 'package:equatable/equatable.dart';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_customer_entity.dart';

class BookBorrowEntity extends Equatable {

  final int id;
  final DateTime endDate;
  final BorrowStatus status;
  final BookBorrowCustomerEntity customer;

  const BookBorrowEntity({
    required this.id,
    required this.endDate,
    required this.status,
    required this.customer
  });

  @override
  List<Object?> get props => [
    id,
    endDate,
    status,
    customer
  ];
}