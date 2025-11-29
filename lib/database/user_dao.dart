import 'package:floor/floor.dart';
import 'user.dart';  // ✅ Chemin correct

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM users WHERE email = :email')
  Future<User?> findUserByEmail(String email);

  @insert
  Future<int> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);

  // ✅ Authentification
  @Query('SELECT * FROM users WHERE email = :email AND password = :password')
  Future<User?> authenticate(String email, String password);

  // ✅ Compter utilisateurs
  @Query('SELECT COUNT(*) FROM users')
  Future<int?> countUsers();
}