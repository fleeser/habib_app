import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';
import 'package:habib_app/src/features/publishers/data/datasources/publisher_datasource.dart';
import 'package:habib_app/src/features/publishers/data/repositories/publisher_repository_impl.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'publisher_repository.g.dart';

@riverpod
PublisherRepository publisherRepository(PublisherRepositoryRef ref) {
  return PublisherRepositoryImpl(
    publisherDatasource: ref.read(publisherDatasourceProvider)
  );
}

abstract interface class PublisherRepository {

  ResultFuture<List<PublisherEntity>> getPublishers({ required String searchText, required int currentPage });

  ResultFuture<int> createPublisher({
    required Json publisherJson
  });

  ResultFuture<PublisherDetailsEntity> getPublisher({ required int publisherId });

  ResultFuture<void> updatePublisher({
    required int publisherId,
    required Json publisherJson
  });

  ResultFuture<void> deletePublisher({ required int publisherId });
}