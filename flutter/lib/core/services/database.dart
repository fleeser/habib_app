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

  Future<List<Json>> getBooks({ required String searchText, required int currentPage }) async {
    String query = '''
      SELECT
        books.id AS book_id,
        books.title AS book_title,
        books.isbn_10 AS book_isbn_10,
        books.isbn_13 AS book_isbn_13,
        books.edition AS book_edition,
        (
          SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
              'author_id', authors.id,
              'author_first_name', authors.first_name,
              'author_last_name', authors.last_name,
              'author_title', authors.title
            )
          )
          FROM authors
          INNER JOIN book_authors ON authors.id = book_authors.author_id
          WHERE book_authors.book_id = books.id
        ) AS authors,
        (
          SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
              'category_id', categories.id,
              'category_name', categories.name
            )
          )
          FROM categories
          INNER JOIN book_categories ON categories.id = book_categories.category_id
          WHERE book_categories.book_id = books.id
        ) AS categories,
        (
          CASE
            WHEN EXISTS (SELECT 1 FROM borrows WHERE borrows.book_id = books.id AND borrows.status <> 'returned') THEN 0
            ELSE 1
          END
        ) AS book_status
      FROM books
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : "books.title LIKE '%$searchText%'" }
      )
      ORDER BY books.title
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getCustomers({ required String searchText, required int currentPage }) async {
    String query = '''
      SELECT
        customers.id AS customer_id,
        customers.first_name AS customer_first_name,
        customers.last_name AS customer_last_name,
        customers.title AS customer_title,
        customers.phone AS customer_phone,
        customers.mobile AS customer_mobile,
        (
          JSON_OBJECT(
            'address_id', addresses.id,
            'address_city', addresses.city,
            'address_postal_code', addresses.postal_code,
            'address_street', addresses.street
          )
        ) AS address
      FROM customers 
      INNER JOIN addresses ON customers.address_id = addresses.id
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : "customers.first_name LIKE '%$searchText%'" }
      )
      ORDER BY customers.last_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getBorrows({ required String searchText, required int currentPage }) async {
    String query = '''
      SELECT
        borrows.id AS borrow_id,
        borrows.end_date AS borrow_end_date,
        (
          CASE
            WHEN borrows.status = 'borrowed' AND borrows.end_date < CURRENT_DATE THEN 'exceeded'
            ELSE borrows.status
          END
        ) AS borrow_status,
        (
          JSON_OBJECT(
            'book_id', books.id,
            'book_title', books.title,
            'book_edition', books.edition
          )
        ) AS book,
        (
          JSON_OBJECT(
            'customer_id', customers.id,
            'customer_first_name', customers.first_name,
            'customer_last_name', customers.last_name,
            'customer_title', customers.title
          )
        ) AS customer
      FROM borrows
      INNER JOIN books ON borrows.book_id = books.id
      INNER JOIN customers ON borrows.customer_id = customers.id
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : "customers.first_name LIKE '%$searchText%'" }
      )
      ORDER BY borrows.created_at
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }
}