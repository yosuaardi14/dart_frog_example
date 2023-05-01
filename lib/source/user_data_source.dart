import 'package:dart_frog_example/database/models/user.dart';
import 'package:dart_frog_example/database/sql_client.dart';

/// data source form MySQL
class UserDataSource {
  /// Returns a singleton
  factory UserDataSource(MySQLClient sqlClient) {
    _instance.sqlClient = sqlClient;
    return _instance;
  }

  UserDataSource._internal();

  static final UserDataSource _instance = UserDataSource._internal();

  /// accessing you client
  late MySQLClient sqlClient;

  ///fetch user by id
  Future<User?> fetchById(String id) async {
    const sqlQuery = 'SELECT id, name, age, image FROM users WHERE id = :id';
    final result = await sqlClient.execute(sqlQuery, params: {'id': id});
    if (result.rows.isNotEmpty) {
      final user = User.fromJson(result.rows.first.assoc());
      return user;
    }
    return null;
  }

  ///fetch all user
  Future<List<User>> fetchAll() async {
    const sqlQuery = 'SELECT id, name, age, image FROM users';
    final result = await sqlClient.execute(sqlQuery);

    final users = <User>[];
    for (final row in result.rows) {
      users.add(User.fromJson(row.assoc()));
    }
    return users;
  }

  ///add user
  Future<User> add(User user) async {
    const sqlQuery =
        'INSERT INTO users (name, age, image) VALUES(:name, :age, :image)';
    final result = await sqlClient.execute(sqlQuery, params: user.toJson());

    final userAdd = await fetchById(result.lastInsertID.toString());
    return userAdd!;
  }

  ///update user
  Future<User> update(String id, User user) async {
    const sqlQuery =
        'UPDATE users SET name= :name, age= :age, image= :image WHERE id = :id';
    await sqlClient.execute(sqlQuery, params: user.toJson());

    final userUp = await fetchById(id);
    return userUp!;
  }

  ///delete user
  Future<User?> delete(String id) async {
    const sqlQuery = 'DELETE FROM users WHERE id = :id';
    await sqlClient.execute(sqlQuery, params: {'id': id});
    return null;
  }
}
