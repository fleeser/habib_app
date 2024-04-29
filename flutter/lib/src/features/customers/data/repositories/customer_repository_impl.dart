import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/data/datasources/customer_datasource.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {

  final CustomerDatasource _customerDatasource;

  const CustomerRepositoryImpl({
    required CustomerDatasource customerDatasource
  })  : _customerDatasource = customerDatasource;

  @override
  ResultFuture<List<CustomerEntity>> getCustomers({ required int currentPage }) async {
    try {
      final List<CustomerDto> result = await _customerDatasource.getCustomers(currentPage: currentPage);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}