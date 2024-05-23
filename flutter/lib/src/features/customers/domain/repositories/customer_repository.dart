import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/data/datasources/customer_datasource.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/repositories/customer_repository_impl.dart';

part 'customer_repository.g.dart';

@riverpod
CustomerRepository customerRepository(CustomerRepositoryRef ref) {
  return CustomerRepositoryImpl(
    customerDatasource: ref.read(customerDatasourceProvider)
  );
}

abstract interface class CustomerRepository {

  ResultFuture<List<CustomerEntity>> getCustomers({ required String searchText, required int currentPage });
}