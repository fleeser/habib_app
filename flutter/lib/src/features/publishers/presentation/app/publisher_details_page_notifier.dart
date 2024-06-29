import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publisher_get_publisher_usecase.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/utils/result.dart';

part 'publisher_details_page_notifier.g.dart';

@riverpod
class PublisherDetailsPageNotifier extends _$PublisherDetailsPageNotifier {

  late PublisherGetPublisherUsecase _publisherGetPublisherUsecase;

  @override
  PublisherDetailsPageState build(int publisherId) {
    _publisherGetPublisherUsecase = ref.read(publisherGetPublisherUsecaseProvider);
    return const PublisherDetailsPageState();
  }

  void replace(PublisherDetailsEntity publisher) {
    state = state.copyWith(publisher: publisher);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isPublisherLoading: true,
      removeError: true
    );

    final PublisherGetPublisherUsecaseParams publisherParams = PublisherGetPublisherUsecaseParams(publisherId: publisherId);
    final Result<PublisherDetailsEntity> result = await _publisherGetPublisherUsecase.call(publisherParams);
    
    result.fold(
      onSuccess: (PublisherDetailsEntity publisher) {
        state = state.copyWith(
          isPublisherLoading: false,
          publisher: publisher
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isPublisherLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class PublisherDetailsPageState extends Equatable {

  final bool isPublisherLoading;
  final ErrorDetails? error;
  final PublisherDetailsEntity? publisher;

  const PublisherDetailsPageState({
    this.isPublisherLoading = false,
    this.error,
    this.publisher
  });

  bool get hasError => error != null;
  bool get isLoading => isPublisherLoading;
  bool get hasPublisher => publisher != null;

  PublisherDetailsPageState copyWith({
    bool? isPublisherLoading = false,
    ErrorDetails? error,
    PublisherDetailsEntity? publisher,
    bool removeError = false,
    bool removePublisher = false
  }) {
    return PublisherDetailsPageState(
      isPublisherLoading: isPublisherLoading ?? this.isPublisherLoading,
      error: removeError ? null : error ?? this.error,
      publisher: removePublisher ? null : publisher ?? this.publisher
    );
  }

  @override
  List<Object?> get props => [
    isPublisherLoading,
    error,
    publisher
  ];
}