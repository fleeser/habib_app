import 'dart:convert';

import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/home/data/dto/new_books_bought_dto.dart';
import 'package:habib_app/src/features/home/data/dto/number_borrowed_books_dto.dart';
import 'package:habib_app/src/features/home/domain/entities/stats_entity.dart';

class StatsDto extends StatsEntity {

  const StatsDto({
    required super.numberBorrowedBooksList,
    required super.newBooksBoughtList
  });

  factory StatsDto.fromJson(Json statsJson) {
    return StatsDto(
      numberBorrowedBooksList: List<Json>.from(json.decode(statsJson['number_borrowed_books'] as String)).map((Json numberBorrowedBooksListJson) => NumberBorrowedBooksDto.fromJson(numberBorrowedBooksListJson)).toList(),
      newBooksBoughtList: List<Json>.from(json.decode(statsJson['new_books_bought'] as String)).map((Json newBooksBoughtListJson) => NewBooksBoughtDto.fromJson(newBooksBoughtListJson)).toList(),
    );
  }
}