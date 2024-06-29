import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_delete_publisher_usecase.g.dart';

@riverpod
PublisherDeletePublisherUsecase publisherDeletePublisherUsecase(PublisherDeletePublisherUsecaseRef ref) {
  return PublisherDeletePublisherUsecase(
    publisherRepository: ref.read(publisherRepositoryProvider)
  );
}

class PublisherDeletePublisherUsecase extends UsecaseWithParams<void, PublisherDeletePublisherUsecaseParams> {

  final PublisherRepository _publisherRepository;

  const PublisherDeletePublisherUsecase({
    required PublisherRepository publisherRepository
  })  : _publisherRepository = publisherRepository;

  @override
  ResultFuture<void> call(PublisherDeletePublisherUsecaseParams params) async {
    return await _publisherRepository.deletePublisher(publisherId: params.publisherId);
  }
}

class PublisherDeletePublisherUsecaseParams extends Equatable {

  final int publisherId;

  const PublisherDeletePublisherUsecaseParams({ required this.publisherId });

  @override
  List<Object?> get props => [
    publisherId
  ];
}