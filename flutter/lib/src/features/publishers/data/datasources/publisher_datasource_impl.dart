import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/publishers/data/datasources/publisher_datasource.dart';
import 'package:habib_app/src/features/publishers/data/dto/publisher_details_dto.dart';
import 'package:habib_app/src/features/publishers/data/dto/publisher_dto.dart';

class PublisherDatasourceImpl implements PublisherDatasource {

  final Database _database;

  const PublisherDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<PublisherDto>> getPublishers({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getPublishers(
      searchText: searchText, 
      currentPage: currentPage
    );
    return PublisherDto.listFromJsonList(jsonList);
  }

  @override
  Future<int> createPublisher({
    required Json publisherJson
  }) async {
    return await _database.createPublisher(publisherJson: publisherJson);
  }

  @override
  Future<PublisherDetailsDto> getPublisher({ required int publisherId }) async {
    final Json json = await _database.getPublisher(publisherId: publisherId);
    return PublisherDetailsDto.fromJson(json);
  }

  @override
  Future<void> updatePublisher({
    required int publisherId,
    required Json publisherJson
  }) async {
    return await _database.updatePublisher(
      publisherId,
      publisherJson
    );
  }

  @override
  Future<void> deletePublisher({ required int publisherId }) async {
    return await _database.deletePublisher(publisherId);
  }
}