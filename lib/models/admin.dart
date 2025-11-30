class Admin {
  final int id;
  final String email;
  final String password;
  final String role;

  Admin({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json['id'] ?? 0,
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    role: json['role'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'role': role,
  };

  // ✅ AUTH SIMPLE (admin@pizza.com / admin123)
  static bool authenticate(String email, String password) {
    return email == 'admin@pizza.com' && password == 'admin123';
  }
}
