import 'dart:convert';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_book_dto.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_customer_dto.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';

class BorrowDto extends BorrowEntity {

  const BorrowDto({
    required super.id,
    required super.book,
    required super.customer,
    required super.endDate,
    required super.status
  });

  factory BorrowDto.fromJson(Json borrowJson) {
    return BorrowDto(
      id: borrowJson['borrow_id'] as int,
      book: BorrowBookDto.fromJson(json.decode(borrowJson['book'] as String)),
      customer: BorrowCustomerDto.fromJson(json.decode(borrowJson['customer'] as String)),
      endDate: borrowJson['borrow_end_date'] as DateTime,
      status: BorrowStatus.fromDatabaseValue(borrowJson['borrow_status'] as String)
    );
  }

  static List<BorrowDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BorrowDto.fromJson(json)).toList();
  }
}