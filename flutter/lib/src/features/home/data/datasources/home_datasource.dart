import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/home/data/datasources/home_datasource_impl.dart';
import 'package:habib_app/src/features/home/data/dto/stats_dto.dart';
import 'package:habib_app/core/services/database.dart';

part 'home_datasource.g.dart';

@riverpod
HomeDatasource homeDatasource(HomeDatasourceRef ref) {
  return HomeDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class HomeDatasource {

  const HomeDatasource();

  Future<StatsDto> getStats({ required int year });
}