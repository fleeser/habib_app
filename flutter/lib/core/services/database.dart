import 'package:habib_app/core/extensions/results_extension.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:mysql1/mysql1.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/utils/env.dart';

part 'database.g.dart';

final ConnectionSettings connectionSettings = ConnectionSettings(
  host: Env.mysqlHost, 
  port: Env.mysqlPort,
  user: Env.mysqlUser,
  password: Env.mysqlPassword,
  db: Env.mysqlDb
);

@riverpod
MySqlConnection mySqlConnection(MySqlConnectionRef ref) {
  throw UnimplementedError();
}

@riverpod
Database database(DatabaseRef ref) {
  return Database(
    connection: ref.read(mySqlConnectionProvider)
  );
}

class Database {

  final MySqlConnection _connection;

  const Database({
    required MySqlConnection connection
  }) : _connection = connection;

  Future<List<Json>> getBooks({ required int currentPage }) async {
    String query = '''
      SELECT * 
      FROM books 
      ORDER BY title
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getCustomers({ required int currentPage }) async {
    String query = '''
      SELECT * 
      FROM customers 
      ORDER BY name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }
}