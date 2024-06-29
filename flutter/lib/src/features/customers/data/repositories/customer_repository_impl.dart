import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/datasources/customer_datasource.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_borrow_dto.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_details_dto.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {

  final CustomerDatasource _customerDatasource;

  const CustomerRepositoryImpl({
    required CustomerDatasource customerDatasource
  })  : _customerDatasource = customerDatasource;

  @override
  ResultFuture<List<CustomerEntity>> getCustomers({ required String searchText, required int currentPage }) async {
    try {
      final List<CustomerDto> result = await _customerDatasource.getCustomers(
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<List<CustomerBorrowEntity>> getCustomerBorrows({ required int customerId, required String searchText, required int currentPage }) async {
    try {
      final List<CustomerBorrowDto> result = await _customerDatasource.getCustomerBorrows(
        customerId: customerId,
        searchText: searchText,
        currentPage: currentPage
      );
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<CustomerDetailsEntity> getCustomer({ required int customerId }) async {
    try {
      final CustomerDetailsDto result = await _customerDatasource.getCustomer(customerId: customerId);
      return Success(result);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<int> createCustomer({
    required Json addressJson,
    required Json customerJson
  }) async {
    try {
      final int customerId = await _customerDatasource.createCustomer(
        addressJson: addressJson,
        customerJson: customerJson
      );
      return Success(customerId);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> updateCustomer({
    required int customerId,
    required int addressId,
    required Json customerJson,
    required Json addressJson
  }) async {
    try {
      await _customerDatasource.updateCustomer(
        customerId: customerId,
        addressId: addressId,
        customerJson: customerJson,
        addressJson: addressJson
      );
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  ResultFuture<void> deleteCustomer({ required int customerId }) async {
    try {
      await _customerDatasource.deleteCustomer(customerId: customerId);
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }
}