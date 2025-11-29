enum UserRole { admin, teacher, student }

class User {
  final String id;
  final String email;
  final String password;
  final UserRole role;
  final String? linkedTeacherId;
  final String? linkedStudentId;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    this.linkedTeacherId,
    this.linkedStudentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role.name,
      'linkedTeacherId': linkedTeacherId,
      'linkedStudentId': linkedStudentId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: UserRole.values.firstWhere((r) => r.name == map['role']),
      linkedTeacherId: map['linkedTeacherId'],
      linkedStudentId: map['linkedStudentId'],
    );
  }
}
