import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/home/domain/entities/stats_entity.dart';
import 'package:habib_app/src/features/home/domain/repositories/home_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'home_get_stats_usecase.g.dart';

@riverpod
HomeGetStatsUsecase homeGetStatsUsecase(HomeGetStatsUsecaseRef ref) {
  return HomeGetStatsUsecase(
    homeRepository: ref.read(homeRepositoryProvider)
  );
}

class HomeGetStatsUsecase extends UsecaseWithParams<StatsEntity, HomeGetStatsUsecaseParams> {

  final HomeRepository _homeRepository;

  const HomeGetStatsUsecase({
    required HomeRepository homeRepository
  })  : _homeRepository = homeRepository;

  @override
  ResultFuture<StatsEntity> call(HomeGetStatsUsecaseParams params) async {
    return await _homeRepository.getStats(year: params.year);
  }
}

class HomeGetStatsUsecaseParams extends Equatable {

  final int year;

  const HomeGetStatsUsecaseParams({ 
    required this.year
  });

  @override
  List<Object?> get props => [
    year
  ];
}