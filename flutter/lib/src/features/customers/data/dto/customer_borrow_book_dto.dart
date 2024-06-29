import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_book_entity.dart';

class CustomerBorrowBookDto extends CustomerBorrowBookEntity {

  const CustomerBorrowBookDto({
    required super.id,
    required super.title,
    super.edition,
  });

  factory CustomerBorrowBookDto.fromJson(Json bookJson) {
    return CustomerBorrowBookDto(
      id: bookJson['book_id'] as int,
      title: bookJson['book_title'] as String,
      edition: bookJson['book_edition'] as int?
    );
  }
}