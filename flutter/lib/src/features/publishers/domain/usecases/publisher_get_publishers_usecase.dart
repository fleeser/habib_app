import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_get_publishers_usecase.g.dart';

@riverpod
PublisherGetPublishersUsecase publisherGetPublishersUsecase(PublisherGetPublishersUsecaseRef ref) {
  return PublisherGetPublishersUsecase(
    publisherRepository: ref.read(publisherRepositoryProvider)
  );
}

class PublisherGetPublishersUsecase extends UsecaseWithParams<List<PublisherEntity>, PublisherGetPublishersUsecaseParams> {

  final PublisherRepository _publisherRepository;

  const PublisherGetPublishersUsecase({
    required PublisherRepository publisherRepository
  })  : _publisherRepository = publisherRepository;

  @override
  ResultFuture<List<PublisherEntity>> call(PublisherGetPublishersUsecaseParams params) async {
    return await _publisherRepository.getPublishers(
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class PublisherGetPublishersUsecaseParams extends Equatable {

  final String searchText;
  final int currentPage;

  const PublisherGetPublishersUsecaseParams({ 
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    searchText,
    currentPage
  ];
}