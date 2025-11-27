import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id; // AUTO INCREMENT sera géré par Floor avec int? nullable
  final String email;
  final String password;
  final String role;

  User({this.id,  this.email,  this.password, this.role });
}
