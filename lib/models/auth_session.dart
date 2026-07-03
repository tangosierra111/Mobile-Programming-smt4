class AuthSession {
  const AuthSession({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

  final int userId;
  final String name;
  final String email;
  final String role;

  bool get canManageContent => role == 'lecturer' || role == 'admin';

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthSession(
      userId: (user['id'] as num).toInt(),
      name: user['name'] as String,
      email: user['email'] as String,
      role: user['role'] as String,
    );
  }
}
