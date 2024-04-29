import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/features/customers/data/datasources/customer_datasource.dart';
import 'package:habib_app/src/features/customers/data/dto/customer_dto.dart';

class CustomerDatasourceImpl implements CustomerDatasource {

  final Database _database;

  const CustomerDatasourceImpl({
    required Database database
  })  : _database = database;

  @override
  Future<List<CustomerDto>> getCustomers({ required int currentPage }) async {
    final List<Json> jsonList = await _database.getCustomers(currentPage: currentPage);
    return CustomerDto.listFromJsonList(jsonList);
  }
}