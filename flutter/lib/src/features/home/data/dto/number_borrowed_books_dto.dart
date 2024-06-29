import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/home/domain/entities/number_borrowed_books_entity.dart';

class NumberBorrowedBooksDto extends NumberBorrowedBooksEntity {

  const NumberBorrowedBooksDto({
    required super.month,
    required super.booksCount
  });

  factory NumberBorrowedBooksDto.fromJson(Json numberBorrowedBooksJson) {
    return NumberBorrowedBooksDto(
      month: numberBorrowedBooksJson['month'] as int,
      booksCount: numberBorrowedBooksJson['books_count'] as int
    );
  }

  static List<NumberBorrowedBooksDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => NumberBorrowedBooksDto.fromJson(json)).toList();
  }
}