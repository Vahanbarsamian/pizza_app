import 'package:floor/floor.dart';

@entity
class User {
  @primaryKey
  final int? id; // AUTO INCREMENT sera géré par Floor avec int? nullable
  final String email;
  final String password;
  final String role;

  User({this.id, required this.email, required this.password, this.role = 'client'});
}
