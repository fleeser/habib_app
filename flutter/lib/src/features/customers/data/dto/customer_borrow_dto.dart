import 'dart:convert';

import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_borrow_book_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';

class CustomerBorrowDto extends CustomerBorrowEntity {

  const CustomerBorrowDto({
    required super.id,
    required super.book,
    required super.endDate,
    required super.status
  });

  factory CustomerBorrowDto.fromJson(Json borrowJson) {
    return CustomerBorrowDto(
      id: borrowJson['borrow_id'] as int,
      book: CustomerBorrowBookDto.fromJson(json.decode(borrowJson['book'] as String)),
      endDate: borrowJson['borrow_end_date'] as DateTime,
      status: BorrowStatus.fromDatabaseValue(borrowJson['borrow_status'] as String)
    );
  }

  static List<CustomerBorrowDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => CustomerBorrowDto.fromJson(json)).toList();
  }
}