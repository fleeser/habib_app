import 'package:equatable/equatable.dart';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_book_entity.dart';

class CustomerBorrowEntity extends Equatable {

  final int id;
  final CustomerBorrowBookEntity book;
  final DateTime endDate;
  final BorrowStatus status;

  const CustomerBorrowEntity({
    required this.id,
    required this.book,
    required this.endDate,
    required this.status
  });

  @override
  List<Object?> get props => [
    id,
    book,
    endDate,
    status
  ];
}