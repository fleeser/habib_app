import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_customer_entity.dart';

class BorrowDetailsCustomerDto extends BorrowDetailsCustomerEntity {

  const BorrowDetailsCustomerDto({
    required super.id,
    super.title,
    required super.firstName,
    required super.lastName
  });

  factory BorrowDetailsCustomerDto.fromJson(Json customerJson) {
    return BorrowDetailsCustomerDto(
      id: customerJson['customer_id'] as int,
      title: customerJson['customer_title'] as String?,
      firstName: customerJson['customer_first_name'] as String,
      lastName: customerJson['customer_last_name'] as String
    );
  }
}