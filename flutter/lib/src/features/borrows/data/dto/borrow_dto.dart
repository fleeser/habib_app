import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/books/data/dto/book_dto.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';
import 'package:habib_app/core/extensions/generic_extension.dart';

class BorrowDto extends BorrowEntity {

  const BorrowDto({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.book,
    super.customer,
    required super.endDate,
    super.status
  });

  factory BorrowDto.fromJson(Json json) {
    return BorrowDto(
      id: json['id'] as int,
      createdAt: json['borrow_created_at'] as DateTime,
      updatedAt: json['borrow_updated_at'] as DateTime,
      book: BookDto.fromJson(json),
      customer: CustomerDto.fromJson(json),
      endDate: json['end_date'] as DateTime,
      status: (json['status'] as String?).whenNotNull<BorrowStatus>((String databaseStatus) => BorrowStatus.fromDatabaseString(databaseStatus))
    );
  }

  static List<BorrowDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => BorrowDto.fromJson(json)).toList();
  }
}