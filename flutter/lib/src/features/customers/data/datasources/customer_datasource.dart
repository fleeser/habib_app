import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_details_dto.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_borrow_dto.dart';
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

  Future<List<CustomerBorrowDto>> getCustomerBorrows({ required int customerId, required String searchText, required int currentPage });

  Future<CustomerDetailsDto> getCustomer({ required int customerId });

  Future<int> createCustomer({
    required Json addressJson,
    required Json customerJson
  });

  Future<void> updateCustomer({
    required int customerId,
    required int addressId,
    required Json customerJson,
    required Json addressJson
  });

  Future<void> deleteCustomer({ required int customerId });
}