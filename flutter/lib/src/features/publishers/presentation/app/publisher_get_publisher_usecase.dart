import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';
import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_get_publisher_usecase.g.dart';

@riverpod
PublisherGetPublisherUsecase publisherGetPublisherUsecase(PublisherGetPublisherUsecaseRef ref) {
  return PublisherGetPublisherUsecase(
    publisherRepository: ref.read(publisherRepositoryProvider)
  );
}

class PublisherGetPublisherUsecase extends UsecaseWithParams<PublisherDetailsEntity, PublisherGetPublisherUsecaseParams> {

  final PublisherRepository _publisherRepository;

  const PublisherGetPublisherUsecase({
    required PublisherRepository publisherRepository
  })  : _publisherRepository = publisherRepository;

  @override
  ResultFuture<PublisherDetailsEntity> call(PublisherGetPublisherUsecaseParams params) async {
    return await _publisherRepository.getPublisher(publisherId: params.publisherId);
  }
}

class PublisherGetPublisherUsecaseParams extends Equatable {

  final int publisherId;

  const PublisherGetPublisherUsecaseParams({ required this.publisherId });

  @override
  List<Object?> get props => [
    publisherId
  ];
}