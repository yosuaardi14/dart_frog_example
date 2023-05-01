import 'package:dart_frog_example/database/models/book.dart';
import 'package:dart_frog_example/database/sql_client.dart';

/// data source form MySQL
class BookDataSource {
  /// Returns a singleton
  factory BookDataSource(MySQLClient sqlClient) {
    _instance.sqlClient = sqlClient;
    return _instance;
  }

  BookDataSource._internal();

  static final BookDataSource _instance = BookDataSource._internal();

  /// accessing you client
  late MySQLClient sqlClient;

  ///fetch Book by id
  Future<Book?> fetchById(String id) async {
    const sqlQuery =
        'SELECT id, title, price, description FROM books WHERE id = :id';
    final result = await sqlClient.execute(sqlQuery, params: {'id': id});
    if (result.rows.isNotEmpty) {
      final book = Book.fromJson(result.rows.first.assoc());
      return book;
    }
    return null;
  }

  ///fetch all Book
  Future<List<Book>> fetchAll() async {
    const sqlQuery = 'SELECT id, title, price, description FROM books';
    final result = await sqlClient.execute(sqlQuery);

    final books = <Book>[];
    for (final row in result.rows) {
      books.add(Book.fromJson(row.assoc()));
    }
    return books;
  }

  ///add Book
  Future<Book> add(Book book) async {
    const sqlQuery =
        'INSERT INTO books (title, price, description) VALUES(:title, :price, :description)';
    final result = await sqlClient.execute(sqlQuery, params: book.toJson());

    final bookAdd = await fetchById(result.lastInsertID.toString());
    return bookAdd!;
  }

  ///update Book
  Future<Book> update(String id, Book book) async {
    const sqlQuery =
        'UPDATE books SET title= :title, price= :price, description= :description WHERE id = :id';
    await sqlClient.execute(sqlQuery, params: book.toJson());

    final bookUp = await fetchById(id);
    return bookUp!;
  }

  ///delete Book
  Future<Book?> delete(String id) async {
    const sqlQuery = 'DELETE FROM books WHERE id = :id';
    await sqlClient.execute(sqlQuery, params: {'id': id});
    return null;
  }
}
