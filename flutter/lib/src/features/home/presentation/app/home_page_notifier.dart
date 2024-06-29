import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/home/domain/entities/stats_entity.dart';
import 'package:habib_app/src/features/home/domain/usecases/home_get_stats_usecase.dart';
import 'package:habib_app/core/utils/result.dart';

part 'home_page_notifier.g.dart';

@riverpod
class HomePageNotifier extends _$HomePageNotifier {

  late HomeGetStatsUsecase _homeGetStatsUsecase;

  @override
  HomePageState build() {
    _homeGetStatsUsecase = ref.read(homeGetStatsUsecaseProvider);
    return const HomePageState();
  }

  Future<void> fetch(int year) async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isStatsLoading: true,
      removeError: true
    );

    final HomeGetStatsUsecaseParams homeGetStatsUsecaseParams = HomeGetStatsUsecaseParams(year: year);
    final Result<StatsEntity> result = await _homeGetStatsUsecase.call(homeGetStatsUsecaseParams);
    
    result.fold(
      onSuccess: (StatsEntity stats) {
        state = state.copyWith(
          isStatsLoading: false,
          stats: stats
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isStatsLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class HomePageState extends Equatable {

  final bool isStatsLoading;
  final ErrorDetails? error;
  final StatsEntity? stats;

  const HomePageState({
    this.isStatsLoading = false,
    this.error,
    this.stats
  });

  bool get hasError => error != null;
  bool get isLoading => isStatsLoading;
  bool get hasStats => stats != null;

  HomePageState copyWith({
    bool? isStatsLoading = false,
    ErrorDetails? error,
    StatsEntity? stats,
    bool removeError = false,
    bool removeStats = false
  }) {
    return HomePageState(
      isStatsLoading: isStatsLoading ?? this.isStatsLoading,
      error: removeError ? null : error ?? this.error,
      stats: removeStats ? null : stats ?? this.stats
    );
  }

  @override
  List<Object?> get props => [
    isStatsLoading,
    error,
    stats
  ];
}