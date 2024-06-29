import 'package:mysql1/mysql1.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/extensions/results_extension.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'database.g.dart';

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

  Future<Json> getStatisticsForYear(int year) async {
    final String query = '''
      WITH months AS (
        SELECT 1 AS month
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        UNION ALL SELECT 10
        UNION ALL SELECT 11
        UNION ALL SELECT 12
      )
      SELECT
        (
          SELECT
            JSON_ARRAYAGG(
              JSON_OBJECT(
                'month', months_with_count.month, 
                'books_count', months_with_count.books_count
              )
            )
          FROM
          (
            SELECT
              months.month,
              COUNT(borrows_in_year.book_id) AS books_count
            FROM
              months
            LEFT JOIN (
              SELECT
                MONTH(borrows.created_at) AS month,
                borrows.book_id
              FROM
                borrows
              WHERE 
                YEAR(borrows.created_at) = $year
            ) borrows_in_year ON months.month = borrows_in_year.month
            GROUP BY 
              months.month
            ORDER BY 
              months.month
          ) AS months_with_count
        ) AS number_borrowed_books,
        (
          
          SELECT
            JSON_ARRAYAGG(
              JSON_OBJECT(
                'month', months_with_count.month, 
                'bought_count', months_with_count.bought_count,
                'not_bought_count', months_with_count.not_bought_count
              )
            )
          FROM
          (
            SELECT
              months.month,
              COALESCE(counts_in_year.bought_count, 0) AS bought_count,
              COALESCE(counts_in_year.not_bought_count, 0) AS not_bought_count
            FROM
              months
            LEFT JOIN (
              SELECT
                MONTH(books.received_at) AS month,
                SUM(CASE WHEN books.bought = 0 THEN 1 ELSE 0 END) AS bought_count,
                SUM(CASE WHEN books.bought = 1 THEN 1 ELSE 0 END) AS not_bought_count
              FROM
                books
              WHERE
                YEAR(books.received_at) = $year
              GROUP BY
                MONTH(books.received_at)
            ) counts_in_year ON months.month = counts_in_year.month
            ORDER BY
              months.month
          ) AS months_with_count
        ) AS new_books_bought
    ''';

    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<List<Json>> getBooks({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.book_id,
        x.book_title,
        x.book_isbn_10,
        x.book_isbn_13,
        x.book_edition,
        x.authors,
        x.categories,
        x.book_status,
        x.cf_search
      FROM
      (
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
          ) AS book_status,
          (LOWER(CONCAT(books.title, ' ', books.isbn_10, ' ', books.isbn_13))) AS cf_search
        FROM books
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.book_title
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getCustomers({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT 
        x.customer_id, 
        x.customer_first_name, 
        x.customer_last_name,
        x.customer_title,
        x.customer_phone,
        x.customer_mobile,
        x.address,
        x.cf_search
      FROM
      (
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
          ) AS address,
          (LOWER(CONCAT(customers.first_name, ' ', customers.last_name, ' ', customers.phone, ' ', customers.mobile))) AS cf_search
        FROM customers 
        INNER JOIN addresses ON customers.address_id = addresses.id
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.customer_last_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getBorrows({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.borrow_id,
        x.borrow_end_date,
        x.borrow_status,
        x.book,
        x.customer,
        x.cf_search
      FROM
      (
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
          ) AS customer,
          (LOWER(CONCAT(borrows.end_date))) AS cf_search
        FROM borrows
        INNER JOIN books ON borrows.book_id = books.id
        INNER JOIN customers ON borrows.customer_id = customers.id
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.borrow_end_date
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getAuthors({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.author_id,
        x.author_first_name,
        x.author_last_name,
        x.author_title,
        x.cf_search
      FROM
      (
        SELECT
          authors.id AS author_id,
          authors.first_name AS author_first_name,
          authors.last_name AS author_last_name,
          authors.title AS author_title,
          (LOWER(CONCAT(authors.first_name, ' ', authors.last_name, ' '))) AS cf_search
        FROM authors 
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.author_last_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getPublishers({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.publisher_id,
        x.publisher_name,
        x.publisher_city,
        x.cf_search
      FROM
      (
        SELECT
          publishers.id AS publisher_id,
          publishers.name AS publisher_name,
          publishers.city AS publisher_city,
          (LOWER(CONCAT(publishers.name, ' ', publishers.city))) AS cf_search
        FROM publishers 
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.publisher_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getCategories({ required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.category_id,
        x.category_name,
        x.cf_search
      FROM
      (
        SELECT
          categories.id AS category_id,
          categories.name AS category_name,
          (LOWER(CONCAT(categories.name))) AS cf_search
        FROM categories 
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.category_name
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<int> createCustomer({
    required Json addressJson,
    required Json customerJson
  }) async {
    final int? customerId = await _connection.transaction<int>((TransactionContext tx) async {
      final String addressQuery = CoreUtils.sqlCreateTextFromJson(
        table: 'addresses', 
        json: addressJson
      );

      final Results addressResults = await tx.query(addressQuery);
      final int addressId = addressResults.insertId!;

      customerJson['address_id'] = addressId;

     final String customerQuery = CoreUtils.sqlCreateTextFromJson(
        table: 'customers', 
        json: customerJson
      );

      final Results customerResults = await tx.query(customerQuery);
      final int customerId = customerResults.insertId!;

      return customerId;
    });

    return customerId!;
  }

  Future<int> createBook({
    required Json bookJson,
    required List<int> authorIds,
    required List<int> categoryIds,
    required List<int> publisherIds
  }) async {
    final int? bookId = await _connection.transaction<int>((TransactionContext tx) async {
      final String bookQuery = CoreUtils.sqlCreateTextFromJson(
        table: 'books', 
        json: bookJson
      );

      final Results bookResults = await tx.query(bookQuery);
      final int bookId = bookResults.insertId!;

      final String authorsQuery = CoreUtils.sqlListCreateTextFromJson(
        table: 'book_authors', 
        columns: <String>[
          'book_id',
          'author_id'
        ], 
        values: authorIds.map((e) => <dynamic>[
          bookId,
          e
        ]).toList()
      );

      await tx.query(authorsQuery);

      final String categoriesQuery = CoreUtils.sqlListCreateTextFromJson(
        table: 'book_categories', 
        columns: <String>[
          'book_id',
          'category_id'
        ], 
        values: categoryIds.map((e) => <dynamic>[
          bookId,
          e
        ]).toList()
      );

      await tx.query(categoriesQuery);

      final String publishersQuery = CoreUtils.sqlListCreateTextFromJson(
        table: 'book_publishers', 
        columns: <String>[
          'book_id',
          'publisher_id'
        ], 
        values: publisherIds.map((e) => <dynamic>[
          bookId,
          e
        ]).toList()
      );

      await tx.query(publishersQuery);

      return bookId;
    });

    return bookId!;
  }

  Future<int> createAuthor({
    required Json authorJson
  }) async {
    final String authorQuery = CoreUtils.sqlCreateTextFromJson(
      table: 'authors', 
      json: authorJson
    );

    final Results authorResults = await _connection.query(authorQuery);
    final int authorId = authorResults.insertId!;

    return authorId;
  }

  Future<int> createPublisher({
    required Json publisherJson
  }) async {
    final String publisherQuery = CoreUtils.sqlCreateTextFromJson(
      table: 'publishers', 
      json: publisherJson
    );

    final Results publisherResults = await _connection.query(publisherQuery);
    final int publisherId = publisherResults.insertId!;

    return publisherId;
  }

  Future<int> createCategory({
    required Json categoryJson
  }) async {
    final String categoryQuery = CoreUtils.sqlCreateTextFromJson(
      table: 'categories', 
      json: categoryJson
    );

    final Results categoryResults = await _connection.query(categoryQuery);
    final int categoryId = categoryResults.insertId!;

    return categoryId;
  }

  Future<int> createBorrow({
    required Json borrowJson
  }) async {
    final String borrowQuery = CoreUtils.sqlCreateTextFromJson(
      table: 'borrows', 
      json: borrowJson
    );

    final Results borrowResults = await _connection.query(borrowQuery);
    final int borrowId = borrowResults.insertId!;

    return borrowId;
  }

  Future<Json> getCustomer({ required int customerId }) async {
    final String query = '''
      SELECT
        customers.id AS customer_id,
        customers.first_name AS customer_first_name,
        customers.last_name AS customer_last_name,
        customers.occupation AS customer_occupation,
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
      WHERE customers.id = $customerId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<Json> getBook({ required int bookId }) async {
    final String query = '''
      SELECT
        books.id AS book_id,
        books.title AS book_title,
        books.isbn_10 AS book_isbn_10,
        books.isbn_13 AS book_isbn_13,
        books.edition AS book_edition,
        books.publish_date AS book_publish_date,
        books.bought AS book_bought,
        books.received_at AS book_received_at,
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
          SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
              'publisher_id', publishers.id,
              'publisher_name', publishers.name,
              'publisher_city', publishers.city
            )
          )
          FROM publishers
          INNER JOIN book_publishers ON publishers.id = book_publishers.publisher_id
          WHERE book_publishers.book_id = books.id
        ) AS publishers
      FROM books
      WHERE books.id = $bookId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<Json> getBorrow({ required int borrowId }) async {
    final String query = '''
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
      INNER JOIN customers ON borrows.customer_id = customers.id
      INNER JOIN books ON borrows.book_id = books.id
      WHERE borrows.id = $borrowId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<Json> getCategory({ required int categoryId }) async {
    final String query = '''
      SELECT
        categories.id AS category_id,
        categories.name AS category_name
      FROM categories
      WHERE categories.id = $categoryId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<Json> getAuthor({ required int authorId }) async {
    final String query = '''
      SELECT
        authors.id AS author_id,
        authors.title AS author_title,
        authors.first_name AS author_first_name,
        authors.last_name AS author_last_name
      FROM authors
      WHERE authors.id = $authorId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<Json> getPublisher({ required int publisherId }) async {
    final String query = '''
      SELECT
        publishers.id AS publisher_id,
        publishers.name AS publisher_name,
        publishers.city AS publisher_city
      FROM publishers
      WHERE publishers.id = $publisherId
    ''';
    final Results results = await _connection.query(query);
    return results.toJson();
  }

  Future<List<Json>> getCustomerBorrows({ required int customerId, required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.borrow_id,
        x.borrow_end_date,
        x.borrow_status,
        x.book,
        x.cf_search
      FROM
      (
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
          (LOWER(CONCAT(borrows.end_date))) AS cf_search
        FROM borrows
        INNER JOIN books ON borrows.book_id = books.id
        INNER JOIN customers ON borrows.customer_id = customers.id
        WHERE customers.id = $customerId
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.borrow_end_date
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<List<Json>> getBookBorrows({ required int bookId, required String searchText, required int currentPage }) async {
    final String query = '''
      SELECT
        x.borrow_id,
        x.borrow_end_date,
        x.borrow_status,
        x.customer,
        x.cf_search
      FROM
      (
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
              'customer_id', customers.id,
              'customer_title', customers.title,
              'customer_first_name', customers.first_name,
              'customer_last_name', customers.last_name
            )
          ) AS customer,
          (LOWER(CONCAT(borrows.end_date))) AS cf_search
        FROM borrows
        INNER JOIN books ON borrows.book_id = books.id
        INNER JOIN customers ON borrows.customer_id = customers.id
        WHERE books.id = $bookId
      ) AS x
      WHERE (
        ${ searchText.isEmpty ? '1 = 1' : CoreUtils.sqlSearchTextFromText(searchText) }
      )
      ORDER BY x.borrow_end_date
      LIMIT ${(currentPage - 1) * NetworkConstants.pageSize}, ${ NetworkConstants.pageSize };
    ''';
    final Results results = await _connection.query(query);
    return results.toJsonList();
  }

  Future<void> updateCustomer(
    int customerId,
    int addressId,
    Json customerJson, 
    Json addressJson
  ) async {
    await _connection.transaction((TransactionContext tx) async {
      if (customerJson.isNotEmpty) {
        final String customerQuery = CoreUtils.sqlUpdateTextFromJson(
          table: 'customers',
          json: customerJson,
          where: 'customers.id = $customerId'
        );
        
        await tx.query(customerQuery);
      }

      if (addressJson.isNotEmpty) {
        final String addressQuery = CoreUtils.sqlUpdateTextFromJson(
          table: 'addresses', 
          json: addressJson,
          where: 'addresses.id = $addressId'
        );

        await tx.query(addressQuery);
      }
    });
  }

  Future<void> updateBook({
    required int bookId,
    required Json bookJson,
    required List<int> removeAuthorIds,
    required List<int> addAuthorIds,
    required List<int> removeCategoryIds,
    required List<int> addCategoryIds,
    required List<int> removePublisherIds,
    required List<int> addPublisherIds
  }) async {
    await _connection.transaction((TransactionContext tx) async {
      if (bookJson.isNotEmpty) {
        final String bookQuery = CoreUtils.sqlUpdateTextFromJson(
          table: 'books',
          json: bookJson,
          where: 'books.id = $bookId'
        );
        
        await tx.query(bookQuery);
      }

      if (removeAuthorIds.isNotEmpty) {
        final String removeAuthorsQuery = '''
          DELETE FROM book_authors
          WHERE book_authors.book_id = $bookId
          AND book_authors.author_id IN (${ removeAuthorIds.join(', ') })
        ''';

        await tx.query(removeAuthorsQuery);
      }

      if (addAuthorIds.isNotEmpty) {
        final String addAuthorsQuery = CoreUtils.sqlListCreateTextFromJson(
          table: 'book_authors', 
          columns: <String>[
            'book_id',
            'author_id'
          ],
          values: addAuthorIds.map((e) => <dynamic>[
            bookId,
            e
          ]).toList()
        );

        await tx.query(addAuthorsQuery);
      }

      if (removeCategoryIds.isNotEmpty) {
        final String removeCategoriesQuery = '''
          DELETE FROM book_categories
          WHERE book_categories.book_id = $bookId
          AND book_categories.category_id IN (${ removeCategoryIds.join(', ') })
        ''';

        await tx.query(removeCategoriesQuery);
      }

      if (addCategoryIds.isNotEmpty) {
        final String addCategoriesQuery = CoreUtils.sqlListCreateTextFromJson(
          table: 'book_categories', 
          columns: <String>[
            'book_id',
            'category_id'
          ],
          values: addCategoryIds.map((e) => <dynamic>[
            bookId,
            e
          ]).toList()
        );

        await tx.query(addCategoriesQuery);
      }

      if (removePublisherIds.isNotEmpty) {
        final String removePublishersQuery = '''
          DELETE FROM book_publishers
          WHERE book_publishers.book_id = $bookId
          AND book_publishers.publisher_id IN (${ removePublisherIds.join(', ') })
        ''';

        await tx.query(removePublishersQuery);
      }

      if (addPublisherIds.isNotEmpty) {
        final String addPublishersQuery = CoreUtils.sqlListCreateTextFromJson(
          table: 'book_publishers', 
          columns: <String>[
            'book_id',
            'publisher_id'
          ],
          values: addPublisherIds.map((e) => <dynamic>[
            bookId,
            e
          ]).toList()
        );

        await tx.query(addPublishersQuery);
      }
    });
  }

  Future<void> updateBorrow(
    int borrowId,
    Json borrowJson
  ) async {
    final String borrowQuery = CoreUtils.sqlUpdateTextFromJson(
      table: 'borrows',
      json: borrowJson,
      where: 'borrows.id = $borrowId'
    );
    
    await _connection.query(borrowQuery);
  }

  Future<void> updateCategory(
    int categoryId,
    Json categoryJson
  ) async {
    final String categoryQuery = CoreUtils.sqlUpdateTextFromJson(
      table: 'categories',
      json: categoryJson,
      where: 'categories.id = $categoryId'
    );
    
    await _connection.query(categoryQuery);
  }

  Future<void> updateAuthor(
    int authorId,
    Json authorJson
  ) async {
    final String authorQuery = CoreUtils.sqlUpdateTextFromJson(
      table: 'authors',
      json: authorJson,
      where: 'authors.id = $authorId'
    );
    
    await _connection.query(authorQuery);
  }

  Future<void> updatePublisher(
    int publisherId,
    Json publisherJson
  ) async {
    final String publisherQuery = CoreUtils.sqlUpdateTextFromJson(
      table: 'publishers',
      json: publisherJson,
      where: 'publishers.id = $publisherId'
    );
    
    await _connection.query(publisherQuery);
  }

  Future<void> deleteCustomer(int customerId) async {
    final String query = 'DELETE FROM customers WHERE customers.id = $customerId';
    await _connection.query(query);
  }

  Future<void> deleteBook(int bookId) async {
    final String query = 'DELETE FROM books WHERE books.id = $bookId';
    await _connection.query(query);
  }

  Future<void> deleteAuthor(int authorId) async {
    final String query = 'DELETE FROM authors WHERE authors.id = $authorId';
    await _connection.query(query);
  }

  Future<void> deletePublisher(int publisherId) async {
    final String query = 'DELETE FROM publishers WHERE publishers.id = $publisherId';
    await _connection.query(query);
  }

  Future<void> deleteCategory(int categoryId) async {
    final String query = 'DELETE FROM categories WHERE categories.id = $categoryId';
    await _connection.query(query);
  }

  Future<void> deleteBorrow(int borrowId) async {
    final String query = 'DELETE FROM borrows WHERE borrows.id = $borrowId';
    await _connection.query(query);
  }
}