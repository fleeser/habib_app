import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/data/datasources/customer_datasource_impl.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';
import 'package:habib_app/core/services/database.dart';

part 'customer_datasource.g.dart';

@riverpod
CustomerDatasource customerDatasource(CustomerDatasourceRef ref) {
  return CustomerDatasourceImpl(
    database: ref.read(databaseProvider)
  );
}

abstract interface class CustomerDatasource {

  const CustomerDatasource();

  Future<List<CustomerDto>> getCustomers({ required String searchText, required int currentPage });
}