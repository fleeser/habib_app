import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/home/data/datasources/home_datasource.dart';
import 'package:habib_app/src/features/home/data/dto/stats_dto.dart';
import 'package:habib_app/src/features/home/domain/entities/stats_entity.dart';
import 'package:habib_app/src/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {

  final HomeDatasource _homeDatasource;

  const HomeRepositoryImpl({
    required HomeDatasource homeDatasource
  })  : _homeDatasource = homeDatasource;

  @override
  ResultFuture<StatsEntity> getStats({ required int year }) async {
    try {
      final StatsDto result = await _homeDatasource.getStats(year: year);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }
}