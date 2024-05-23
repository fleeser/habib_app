import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_customer_entity.dart';

class BorrowCustomerDto extends BorrowCustomerEntity {

  const BorrowCustomerDto({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.title
  });

  factory BorrowCustomerDto.fromJson(Json customerJson) {
    return BorrowCustomerDto(
      id: customerJson['customer_id'] as int,
      firstName: customerJson['customer_first_name'] as String,
      lastName: customerJson['customer_last_name'] as String,
      title: customerJson['customer_title'] as String?
    );
  }
}