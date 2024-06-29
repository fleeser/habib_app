import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/domain/entities/book_borrow_customer_entity.dart';

class BookBorrowCustomerDto extends BookBorrowCustomerEntity {

  const BookBorrowCustomerDto({
    required super.id,
    super.title,
    required super.firstName,
    required super.lastName
  });

  factory BookBorrowCustomerDto.fromJson(Json customerJson) {
    return BookBorrowCustomerDto(
      id: customerJson['customer_id'] as int,
      title: customerJson['customer_title'] as String?,
      firstName: customerJson['customer_first_name'] as String,
      lastName: customerJson['customer_last_name'] as String
    );
  }
}