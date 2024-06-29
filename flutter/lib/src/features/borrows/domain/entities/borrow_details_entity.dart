import 'package:equatable/equatable.dart';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_book_entity.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_customer_entity.dart';

class BorrowDetailsEntity extends Equatable {

  final int id;
  final BorrowDetailsBookEntity book;
  final BorrowDetailsCustomerEntity customer;
  final DateTime endDate;
  final BorrowStatus status;

  const BorrowDetailsEntity({
    required this.id,
    required this.book,
    required this.customer,
    required this.endDate,
    required this.status
  });

  @override
  List<Object?> get props => [
    id,
    book,
    customer,
    endDate,
    status
  ];
}