import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/data_service.dart';
import '../bloc/courses/courses_bloc.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import 'package:get_it/get_it.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  void _addCourse() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final creditsController = TextEditingController();
    final teacherIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить курс'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название курса'),
            ),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Код курса'),
            ),
            TextField(
              controller: creditsController,
              decoration: const InputDecoration(labelText: 'Часы'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: teacherIdController,
              decoration: const InputDecoration(labelText: 'ID преподавателя'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  codeController.text.isNotEmpty) {
                final newCourse = Course(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  code: codeController.text,
                  credits: int.tryParse(creditsController.text) ?? 3,
                  teacherId: teacherIdController.text,
                );
                context.read<CoursesBloc>().add(CourseAdded(newCourse));
                context.pop();
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _enrollStudent(Course course) {
    String selectedStudentId = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Записать студента'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Курс: ${course.name}'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedStudentId.isEmpty ? null : selectedStudentId,
              hint: const Text('Выберите студента'),
              items: GetIt.I<DataService>().students
                  .map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudentId = value ?? '';
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (selectedStudentId.isNotEmpty) {
                context.read<CoursesBloc>().add(
                  StudentEnrolled(course.id, selectedStudentId),
                );
                context.pop();
              }
            },
            child: const Text('Записать'),
          ),
        ],
      ),
    );
  }

  void _deleteCourse(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить курс'),
        content: Text('Вы уверены, что хотите удалить ${course.name}?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<CoursesBloc>().add(CourseDeleted(course.id));
              context.pop();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesBloc()..add(CoursesLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Курсы'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                GetIt.I<AuthService>().logout();
                context.go('/login');
              },
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CourseCard(
                    course: course,
                    teacher: GetIt.I<DataService>().teachers.firstWhere(
                      (t) => t.id == course.teacherId,
                    ),
                    onEnrollStudent:
                        (GetIt.I<AuthService>().currentUser?.role ==
                                UserRole.admin ||
                            (GetIt.I<AuthService>().currentUser?.role ==
                                    UserRole.teacher &&
                                GetIt.I<AuthService>()
                                        .currentUser
                                        ?.linkedTeacherId ==
                                    course.teacherId))
                        ? () => _enrollStudent(course)
                        : null,
                    onEdit: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Находится в разработке...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onDelete:
                        GetIt.I<AuthService>().currentUser?.role ==
                            UserRole.admin
                        ? () => _deleteCourse(course)
                        : null,
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton:
            GetIt.I<AuthService>().currentUser?.role == UserRole.admin
            ? FloatingActionButton(
                onPressed: _addCourse,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

// Встраиваемый контент курсов без собственного AppBar
class CoursesContent extends StatefulWidget {
  const CoursesContent({super.key});

  @override
  State<CoursesContent> createState() => _CoursesContentState();
}

class _CoursesContentState extends State<CoursesContent> {
  List<Course> get _visibleCourses {
    final role = GetIt.I<AuthService>().currentUser?.role;
    if (role == UserRole.admin) return GetIt.I<DataService>().courses;
    if (role == UserRole.teacher) {
      final teacherId = GetIt.I<AuthService>().currentUser?.linkedTeacherId;
      return GetIt.I<DataService>().courses
          .where((c) => c.teacherId == teacherId)
          .toList();
    }
    if (role == UserRole.student) {
      final studentId = GetIt.I<AuthService>().currentUser?.linkedStudentId;
      final student = GetIt.I<DataService>().students.firstWhere(
        (s) => s.id == studentId,
        orElse: () =>
            Student(id: '', name: '', email: '', enrolledCourses: const []),
      );
      return GetIt.I<DataService>().courses
          .where((c) => student.enrolledCourses.contains(c.id))
          .toList();
    }
    return [];
  }

  void _addCourse() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final creditsController = TextEditingController();
    final teacherIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить курс'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название курса'),
            ),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Код курса'),
            ),
            TextField(
              controller: creditsController,
              decoration: const InputDecoration(labelText: 'Часы'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: teacherIdController,
              decoration: const InputDecoration(labelText: 'ID преподавателя'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  codeController.text.isNotEmpty) {
                final newCourse = Course(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  code: codeController.text,
                  credits: int.tryParse(creditsController.text) ?? 3,
                  teacherId: teacherIdController.text,
                );
                setState(() {
                  GetIt.I<DataService>().addCourse(newCourse);
                });
                context.pop();
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _enrollStudent(Course course) {
    String selectedStudentId = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Записать студента'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Курс: ${course.name}'),
            DropdownButton<String>(
              value: selectedStudentId.isEmpty ? null : selectedStudentId,
              hint: const Text('Выберите студента'),
              items: GetIt.I<DataService>().students
                  .map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudentId = value ?? '';
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (selectedStudentId.isNotEmpty) {
                setState(() {
                  GetIt.I<DataService>().enrollStudentInCourse(
                    course.id,
                    selectedStudentId,
                  );
                });
                context.pop();
              }
            },
            child: const Text('Записать'),
          ),
        ],
      ),
    );
  }

  void _deleteCourse(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить курс'),
        content: Text('Вы уверены, что хотите удалить ${course.name}?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                GetIt.I<DataService>().deleteCourse(course.id);
              });
              context.pop();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _visibleCourses.length,
        itemBuilder: (context, index) {
          final course = _visibleCourses[index];
          final teacher = GetIt.I<DataService>().teachers.firstWhere(
            (t) => t.id == course.teacherId,
            orElse: () => Teacher(
              id: '',
              name: 'Неизвестно',
              email: '',
              department: '',
              position: '',
              phoneNumber: '',
              subjects: const [],
            ),
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CourseCard(
              course: course,
              teacher: teacher,
              onEnrollStudent:
                  (GetIt.I<AuthService>().currentUser?.role == UserRole.admin ||
                      (GetIt.I<AuthService>().currentUser?.role ==
                              UserRole.teacher &&
                          GetIt.I<AuthService>().currentUser?.linkedTeacherId ==
                              course.teacherId))
                  ? () => _enrollStudent(course)
                  : null,
              onEdit: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Находится в разработке...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onDelete:
                  GetIt.I<AuthService>().currentUser?.role == UserRole.admin
                  ? () => _deleteCourse(course)
                  : null,
            ),
          );
        },
      ),
      floatingActionButton:
          GetIt.I<AuthService>().currentUser?.role == UserRole.admin
          ? FloatingActionButton(
              onPressed: _addCourse,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
