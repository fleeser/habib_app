import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/publishers/data/dto/publisher_details_dto.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/publishers/data/dto/publisher_dto.dart';
import 'package:habib_app/src/features/publishers/data/datasources/publisher_datasource_impl.dart';
import 'package:habib_app/core/services/database.dart';

part 'publisher_datasource.g.dart';

@riverpod
PublisherDatasource publisherDatasource(PublisherDatasourceRef ref) {
  return PublisherDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class PublisherDatasource {

  const PublisherDatasource();

  Future<List<PublisherDto>> getPublishers({ required String searchText, required int currentPage });

  Future<int> createPublisher({
    required Json publisherJson
  });

  Future<PublisherDetailsDto> getPublisher({ required int publisherId });

  Future<void> updatePublisher({
    required int publisherId,
    required Json publisherJson
  });

  Future<void> deletePublisher({ required int publisherId });
}