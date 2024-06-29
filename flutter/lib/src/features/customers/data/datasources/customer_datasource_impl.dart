import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/customers/data/datasources/customer_datasource.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_borrow_dto.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_details_dto.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';

class CustomerDatasourceImpl implements CustomerDatasource {

  final Database _database;

  const CustomerDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<CustomerDto>> getCustomers({ required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getCustomers(
      searchText: searchText, 
      currentPage: currentPage
    );
    return CustomerDto.listFromJsonList(jsonList);
  }

  @override
  Future<List<CustomerBorrowDto>> getCustomerBorrows({ required int customerId, required String searchText, required int currentPage }) async {
    final List<Json> jsonList = await _database.getCustomerBorrows(
      customerId: customerId,
      searchText: searchText, 
      currentPage: currentPage
    );
    return CustomerBorrowDto.listFromJsonList(jsonList);
  }

  @override
  Future<CustomerDetailsDto> getCustomer({ required int customerId }) async {
    final Json json = await _database.getCustomer(customerId: customerId);
    return CustomerDetailsDto.fromJson(json);
  }

  @override
  Future<int> createCustomer({
    required Json addressJson,
    required Json customerJson
  }) async {
    return await _database.createCustomer(
      addressJson: addressJson, 
      customerJson: customerJson
    );
  }

  @override
  Future<void> updateCustomer({
    required int customerId,
    required int addressId,
    required Json customerJson,
    required Json addressJson
  }) async {
    return await _database.updateCustomer(customerId, addressId, customerJson, addressJson);
  }

  @override
  Future<void> deleteCustomer({ required int customerId }) async {
    return await _database.deleteCustomer(customerId);
  }
}