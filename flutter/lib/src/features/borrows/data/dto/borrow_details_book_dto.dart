import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_book_entity.dart';

class BorrowDetailsBookDto extends BorrowDetailsBookEntity {

  const BorrowDetailsBookDto({
    required super.id,
    required super.title,
    super.edition
  });

  factory BorrowDetailsBookDto.fromJson(Json bookJson) {
    return BorrowDetailsBookDto(
      id: bookJson['book_id'] as int,
      title: bookJson['book_title'] as String,
      edition: bookJson['book_edition'] as int?
    );
  }
}