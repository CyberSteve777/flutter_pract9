import '../models/user.dart';

class AuthService {
  final List<User> _users = [
    User(
      id: 'admin1',
      email: 'admin@university.edu',
      password: 'admin123',
      role: UserRole.admin,
    ),
    User(
      id: 'admin2',
      email: 'superadmin@university.edu',
      password: 'admin456',
      role: UserRole.admin,
    ),
    // Преподаватели (существующие из DataService)
    User(
      id: 't1',
      email: 'smirnov@university.edu',
      password: 'teacher1',
      role: UserRole.teacher,
      linkedTeacherId: '1',
    ),
    User(
      id: 't2',
      email: 'ivanova@university.edu',
      password: 'teacher2',
      role: UserRole.teacher,
      linkedTeacherId: '2',
    ),
    User(
      id: 't3',
      email: 'belov@university.edu',
      password: 'teacher3',
      role: UserRole.teacher,
      linkedTeacherId: '3',
    ),
    // Студенты (существующие из DataService)
    User(
      id: 's1',
      email: 'ivanov@student.edu',
      password: 'student1',
      role: UserRole.student,
      linkedStudentId: '1',
    ),
    User(
      id: 's2',
      email: 'petrova@student.edu',
      password: 'student2',
      role: UserRole.student,
      linkedStudentId: '2',
    ),
    User(
      id: 's3',
      email: 'sidorov@student.edu',
      password: 'student3',
      role: UserRole.student,
      linkedStudentId: '3',
    ),
    User(
      id: 's4',
      email: 'guseva@student.edu',
      password: 'student4',
      role: UserRole.student,
      linkedStudentId: '4',
    ),
  ];

  User? currentUser;

  List<User> get users => List.unmodifiable(_users);

  bool login(String email, String password) {
    final user = _users.firstWhere(
      (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase(),
      orElse: () =>
          const User(id: '', email: '', password: '', role: UserRole.student),
    );
    if (user.id.isEmpty) return false;
    if (user.password != password) return false;
    currentUser = user;
    return true;
  }

  void logout() {
    currentUser = null;
  }

  void updateCurrentUser({String? email, String? password}) {
    if (currentUser == null) return;
    final updated = User(
      id: currentUser!.id,
      email: email ?? currentUser!.email,
      password: password ?? currentUser!.password,
      role: currentUser!.role,
      linkedTeacherId: currentUser!.linkedTeacherId,
      linkedStudentId: currentUser!.linkedStudentId,
    );
    final index = _users.indexWhere((u) => u.id == currentUser!.id);
    if (index != -1) {
      _users[index] = updated;
    }
    currentUser = updated;
  }
}
