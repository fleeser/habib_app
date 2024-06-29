import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_create_publisher_usecase.g.dart';

@riverpod
PublisherCreatePublisherUsecase publisherCreatePublisherUsecase(PublisherCreatePublisherUsecaseRef ref) {
  return PublisherCreatePublisherUsecase(
    publisherRepository: ref.read(publisherRepositoryProvider)
  );
}

class PublisherCreatePublisherUsecase extends UsecaseWithParams<int, PublisherCreatePublisherUsecaseParams> {

  final PublisherRepository _publisherRepository;

  const PublisherCreatePublisherUsecase({
    required PublisherRepository publisherRepository
  })  : _publisherRepository = publisherRepository;

  @override
  ResultFuture<int> call(PublisherCreatePublisherUsecaseParams params) async {
    return await _publisherRepository.createPublisher(publisherJson: params.publisherJson);
  }
}

class PublisherCreatePublisherUsecaseParams extends Equatable {

  final Json publisherJson;

  const PublisherCreatePublisherUsecaseParams({ 
    required this.publisherJson
  });

  @override
  List<Object?> get props => [
    publisherJson
  ];
}