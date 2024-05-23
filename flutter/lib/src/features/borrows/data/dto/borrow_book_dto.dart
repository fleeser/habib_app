import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_book_entity.dart';

class BorrowBookDto extends BorrowBookEntity {

  const BorrowBookDto({
    required super.id,
    required super.title,
    super.edition,
  });

  factory BorrowBookDto.fromJson(Json bookJson) {
    return BorrowBookDto(
      id: bookJson['book_id'] as int,
      title: bookJson['book_title'] as String,
      edition: bookJson['book_edition'] as int?
    );
  }
}