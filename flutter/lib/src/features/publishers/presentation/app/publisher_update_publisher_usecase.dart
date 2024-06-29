import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_update_publisher_usecase.g.dart';

@riverpod
PublisherUpdatePublisherUsecase publisherUpdatePublisherUsecase(PublisherUpdatePublisherUsecaseRef ref) {
  return PublisherUpdatePublisherUsecase(
    publisherRepository: ref.read(publisherRepositoryProvider)
  );
}

class PublisherUpdatePublisherUsecase extends UsecaseWithParams<void, PublisherUpdatePublisherUsecaseParams> {

  final PublisherRepository _publisherRepository;

  const PublisherUpdatePublisherUsecase({
    required PublisherRepository publisherRepository
  })  : _publisherRepository = publisherRepository;

  @override
  ResultFuture<void> call(PublisherUpdatePublisherUsecaseParams params) async {
    return await _publisherRepository.updatePublisher(
      publisherId: params.publisherId,
      publisherJson: params.publisherJson
    );
  }
}

class PublisherUpdatePublisherUsecaseParams extends Equatable {

  final int publisherId;
  final Json publisherJson;

  const PublisherUpdatePublisherUsecaseParams({ 
    required this.publisherId,
    required this.publisherJson
  });

  @override
  List<Object?> get props => [
    publisherId,
    publisherJson
  ];
}