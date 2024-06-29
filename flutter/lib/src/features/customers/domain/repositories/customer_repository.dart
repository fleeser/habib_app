import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';
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

  ResultFuture<List<CustomerBorrowEntity>> getCustomerBorrows({ required int customerId, required String searchText, required int currentPage });

  ResultFuture<CustomerDetailsEntity> getCustomer({ required int customerId });

  ResultFuture<int> createCustomer({
    required Json addressJson,
    required Json customerJson
  });

  ResultFuture<void> updateCustomer({
    required int customerId,
    required int addressId,
    required Json customerJson,
    required Json addressJson
  });

  ResultFuture<void> deleteCustomer({ required int customerId });
}