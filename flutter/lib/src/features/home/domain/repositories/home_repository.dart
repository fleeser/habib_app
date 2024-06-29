import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:habib_app/src/features/home/domain/entities/stats_entity.dart';
import 'package:habib_app/src/features/home/data/datasources/home_datasource.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl(
    homeDatasource: ref.read(homeDatasourceProvider)
  );
}

abstract interface class HomeRepository {

  ResultFuture<StatsEntity> getStats({ required int year });
}