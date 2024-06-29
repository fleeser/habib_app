import 'dart:convert';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_details_book_dto.dart';
import 'package:habib_app/src/features/borrows/data/dto/borrow_details_customer_dto.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_entity.dart';

class BorrowDetailsDto extends BorrowDetailsEntity {

  const BorrowDetailsDto({
    required super.id,
    required super.book,
    required super.customer,
    required super.endDate,
    required super.status
  });

  factory BorrowDetailsDto.fromJson(Json borrowJson) {
    return BorrowDetailsDto(
      id: borrowJson['borrow_id'] as int,
      book: BorrowDetailsBookDto.fromJson(json.decode(borrowJson['book'] as String)),
      customer: BorrowDetailsCustomerDto.fromJson(json.decode(borrowJson['customer'] as String)),
      endDate: borrowJson['borrow_end_date'] as DateTime,
      status: BorrowStatus.fromDatabaseValue(borrowJson['borrow_status'] as String)
    );
  }

  static List<BorrowDetailsDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BorrowDetailsDto.fromJson(json)).toList();
  }
}