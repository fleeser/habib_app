import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/src/features/publishers/domain/usecases/publisher_get_publishers_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'publishers_page_notifier.g.dart';

@riverpod
class PublishersPageNotifier extends _$PublishersPageNotifier {

  late PublisherGetPublishersUsecase _publisherGetPublishersUsecase;

  @override
  PublishersPageState build() {
    _publisherGetPublishersUsecase = ref.read(publisherGetPublishersUsecaseProvider);
    return const PublishersPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isPublishersLoading: true,
      removeError: true
    );

    final PublisherGetPublishersUsecaseParams params = PublisherGetPublishersUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<PublisherEntity>> result = await _publisherGetPublishersUsecase.call(params);
    
    result.fold(
      onSuccess: (List<PublisherEntity> publishers) {
        state = state.copyWith(
          isPublishersLoading: false,
          currentPage: publishers.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          publishers: List.of(state.publishers)..addAll(publishers),
          hasReachedEnd: publishers.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isPublishersLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const PublishersPageState();
    await fetchNextPage(searchText);
  }
}

class PublishersPageState extends Equatable {

  final bool isPublishersLoading;
  final ErrorDetails? error;
  final List<PublisherEntity> publishers;
  final bool hasReachedEnd;
  final int currentPage;

  const PublishersPageState({
    this.isPublishersLoading = false,
    this.error,
    this.publishers = const <PublisherEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isPublishersLoading;
  bool get hasPublishers => publishers.isNotEmpty;

  PublishersPageState copyWith({
    bool? isPublishersLoading = false,
    ErrorDetails? error,
    List<PublisherEntity>? publishers,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removePublishers = false
  }) {
    return PublishersPageState(
      isPublishersLoading: isPublishersLoading ?? this.isPublishersLoading,
      error: removeError ? null : error ?? this.error,
      publishers: removePublishers ? const <PublisherEntity>[] : publishers ?? this.publishers,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isPublishersLoading,
    error,
    publishers,
    hasReachedEnd,
    currentPage
  ];
}