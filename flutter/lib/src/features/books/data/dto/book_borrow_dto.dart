import 'dart:convert';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/dto/book_borrow_customer_dto.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';

class BookBorrowDto extends BookBorrowEntity {

  const BookBorrowDto({
    required super.id,
    required super.customer,
    required super.endDate,
    required super.status
  });

  factory BookBorrowDto.fromJson(Json borrowJson) {
    return BookBorrowDto(
      id: borrowJson['borrow_id'] as int,
      customer: BookBorrowCustomerDto.fromJson(json.decode(borrowJson['customer'] as String)),
      endDate: borrowJson['borrow_end_date'] as DateTime,
      status: BorrowStatus.fromDatabaseValue(borrowJson['borrow_status'] as String)
    );
  }

  static List<BookBorrowDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BookBorrowDto.fromJson(json)).toList();
  }
}