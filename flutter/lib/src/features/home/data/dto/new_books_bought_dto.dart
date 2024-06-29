import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/home/domain/entities/new_books_bought_entity.dart';

class NewBooksBoughtDto extends NewBooksBoughtEntity {

  const NewBooksBoughtDto({
    required super.month,
    required super.boughtCount,
    required super.notBoughtCount
  });

  factory NewBooksBoughtDto.fromJson(Json newbooksBoughtJson) {
    return NewBooksBoughtDto(
      month: newbooksBoughtJson['month'] as int,
      boughtCount: newbooksBoughtJson['bought_count'] as int,
      notBoughtCount: newbooksBoughtJson['not_bought_count'] as int
    );
  }

  static List<NewBooksBoughtDto> listFromJsonList(List<Json> jsonList) {
    return jsonList.map((Json json) => NewBooksBoughtDto.fromJson(json)).toList();
  }
}