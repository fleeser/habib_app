import 'package:mysql1/mysql1.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/extensions/results_extension.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/typedefs.dart';
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
      SELECT
        books.id AS book_id,
        books.created_at AS book_created_at,
        books.updated_at AS book_updated_at,
        books.title AS book_title,
        books.isbn_10 AS book_isbn_10,
        books.isbn_13 AS book_isbn_13,
        books.edition AS book_edition,
        books.publish_date AS book_publish_date,
        books.bought AS book_bought,
        publishers.id AS publisher_id,
        publishers.created_at AS publisher_created_at,
        publishers.updated_at AS publisher_updated_at,
        publishers.name AS publisher_name,
        publishers.city AS publisher_city,
        authors.id AS author_id,
        authors.created_at AS author_created_at,
        authors.updated_at AS author_updated_at,
        authors.first_name AS author_first_name,
        authors.last_name AS author_last_name,
        authors.title AS author_title
      FROM books 
      LEFT JOIN publishers ON books.publisher_id = publishers.id
      LEFT JOIN authors ON books.author_id = authors.id
      ORDER BY books.title
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getCustomers({ required int currentPage }) async {
    String query = '''
      SELECT
        customers.id AS customer_id,
        customers.created_at AS customer_created_at,
        customers.updated_at AS customer_updated_at,
        customers.first_name AS customer_first_name,
        customers.last_name AS customer_last_name,
        customers.title AS customer_title,
        customers.occupation AS customer_occupation,
        customers.phone AS customer_phone,
        customers.mobile AS customer_mobile,
        addresses.id AS address_id,
        addresses.created_at AS address_created_at,
        addresses.updated_at AS address_updated_at,
        addresses.city AS address_city,
        addresses.postal_code AS address_postal_code,
        addresses.street AS address_street
      FROM customers 
      LEFT JOIN addresses ON customers.address_id = addresses.id
      ORDER BY customers.last_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getBorrows({ required int currentPage }) async {
    String query = '''
      SELECT
        borrows.id AS borrow_id,
        borrows.created_at AS borrow_created_at,
        borrows.updated_at AS borrow_updated_at,
        borrows.end_date AS borrow_end_date,
        borrows.status AS borrow_status,
        books.id AS book_id,
        books.created_at AS book_created_at,
        books.updated_at AS book_updated_at,
        books.title AS book_title,
        books.isbn_10 AS book_isbn_10,
        books.isbn_13 AS book_isbn_13,
        books.edition AS book_edition,
        books.publish_date AS book_publish_date,
        books.bought AS book_bought,
        publishers.id AS publisher_id,
        publishers.created_at AS publisher_created_at,
        publishers.updated_at AS publisher_updated_at,
        publishers.name AS publisher_name,
        publishers.city AS publisher_city,
        authors.id AS author_id,
        authors.created_at AS author_created_at,
        authors.updated_at AS author_updated_at,
        authors.first_name AS author_first_name,
        authors.last_name AS author_last_name,
        authors.title AS author_title,
        customers.id AS customer_id,
        customers.created_at AS customer_created_at,
        customers.updated_at AS customer_updated_at,
        customers.first_name AS customer_first_name,
        customers.last_name AS customer_last_name,
        customers.title AS customer_title,
        customers.occupation AS customer_occupation,
        customers.phone AS customer_phone,
        customers.mobile AS customer_mobile,
        addresses.id AS address_id,
        addresses.created_at AS address_created_at,
        addresses.updated_at AS address_updated_at,
        addresses.city AS address_city,
        addresses.postal_code AS address_postal_code,
        addresses.street AS address_street
      FROM borrows
      LEFT JOIN books ON borrows.book_id = books.id
      LEFT JOIN customers ON borrows.customer_id = customers.id
      LEFT JOIN publishers ON books.publisher_id = publishers.id
      LEFT JOIN authors ON books.author_id = authors.id
      LEFT JOIN addresses ON customers.address_id = addresses.id
      ORDER BY borrows.created_at
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }
}