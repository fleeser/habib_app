import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/publishers/data/datasources/publisher_datasource.dart';
import 'package:habib_app/src/features/publishers/data/dto/publisher_details_dto.dart';
import 'package:habib_app/src/features/publishers/data/dto/publisher_dto.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/src/features/publishers/domain/repositories/publisher_repository.dart';

class PublisherRepositoryImpl implements PublisherRepository {

  final PublisherDatasource _publisherDatasource;

  const PublisherRepositoryImpl({
    required PublisherDatasource publisherDatasource
  })  : _publisherDatasource = publisherDatasource;

  @override
  ResultFuture<List<PublisherEntity>> getPublishers({ required String searchText, required int currentPage }) async {
    try {
      final List<PublisherDto> result = await _publisherDatasource.getPublishers(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createPublisher({
    required Json publisherJson
  }) async {
    try {
      final int publisherId = await _publisherDatasource.createPublisher(publisherJson: publisherJson);
      return Success(publisherId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<PublisherDetailsEntity> getPublisher({ required int publisherId }) async {
    try {
      final PublisherDetailsDto result = await _publisherDatasource.getPublisher(publisherId: publisherId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updatePublisher({
    required int publisherId,
    required Json publisherJson
  }) async {
    try {
      await _publisherDatasource.updatePublisher(
        publisherId: publisherId,
        publisherJson: publisherJson
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deletePublisher({ required int publisherId }) async {
    try {
      await _publisherDatasource.deletePublisher(publisherId: publisherId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}