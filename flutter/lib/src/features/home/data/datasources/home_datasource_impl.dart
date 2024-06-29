import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/home/data/datasources/home_datasource.dart';
import 'package:habib_app/src/features/home/data/dto/stats_dto.dart';

class HomeDatasourceImpl implements HomeDatasource {

  final Database _database;

  const HomeDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<StatsDto> getStats({ required int year }) async {
    final Json json = await _database.getStatisticsForYear(year);
    return StatsDto.fromJson(json);
  }
}