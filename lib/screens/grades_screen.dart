import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/data_service.dart';
import '../bloc/grades/grades_bloc.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import 'package:get_it/get_it.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  void _addGrade() {
    final gradeController = TextEditingController();
    String selectedStudentId = '';
    String selectedCourseId = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Добавить оценку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedStudentId.isEmpty ? null : selectedStudentId,
                hint: const Text('Выберите студента'),
                items: GetIt.I<DataService>().students.map((student) {
                  return DropdownMenuItem(
                    value: student.id,
                    child: Text(student.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStudentId = value ?? '';
                  });
                },
              ),
              DropdownButton<String>(
                value: selectedCourseId.isEmpty ? null : selectedCourseId,
                hint: const Text('Выберите курс'),
                items: GetIt.I<DataService>().courses.map((course) {
                  return DropdownMenuItem(
                    value: course.id,
                    child: Text(course.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value ?? '';
                  });
                },
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Оценка (0–100)'),
                keyboardType: TextInputType.number,
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
                final grade = double.tryParse(gradeController.text);
                if (selectedStudentId.isNotEmpty &&
                    selectedCourseId.isNotEmpty &&
                    grade != null) {
                  final newGrade = Grade(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    studentId: selectedStudentId,
                    courseId: selectedCourseId,
                    grade: grade,
                    date: DateTime.now(),
                    comments: '',
                  );
                  context.read<GradesBloc>().add(GradeAdded(newGrade));
                  context.pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  void _editGrade(Grade grade) {
    final gradeController = TextEditingController(text: grade.grade.toString());
    final commentsController = TextEditingController(
      text: grade.comments ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать оценку'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Оценка (0–100)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: commentsController,
              decoration: const InputDecoration(labelText: 'Комментарий'),
              maxLines: 3,
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
              final newGrade = double.tryParse(gradeController.text);
              if (newGrade != null) {
                final updatedGrade = Grade(
                  id: grade.id,
                  studentId: grade.studentId,
                  courseId: grade.courseId,
                  grade: newGrade,
                  date: grade.date,
                  comments: commentsController.text,
                );
                context.read<GradesBloc>().add(GradeUpdated(updatedGrade));
                context.pop();
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteGrade(Grade grade) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить оценку'),
        content: const Text('Вы уверены, что хотите удалить эту оценку?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<GradesBloc>().add(GradeDeleted(grade.id));
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
      create: (_) => GradesBloc()..add(GradesLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Оценки'),
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
        body: BlocBuilder<GradesBloc, GradesState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.grades.length,
              itemBuilder: (context, index) {
                final grade = state.grades[index];
                final student = GetIt.I<DataService>().students.firstWhere(
                  (s) => s.id == grade.studentId,
                  orElse: () => Student(
                    id: '',
                    name: 'Неизвестно',
                    email: '',
                    enrolledCourses: const [],
                  ),
                );
                final course = GetIt.I<DataService>().courses.firstWhere(
                  (c) => c.id == grade.courseId,
                  orElse: () => Course(
                    id: '',
                    name: 'Неизвестно',
                    code: '',
                    credits: 0,
                    teacherId: '',
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GradeCard(
                    grade: grade,
                    student: student,
                    course: course,
                    onEdit:
                        (GetIt.I<AuthService>().currentUser?.role ==
                                UserRole.admin ||
                            (GetIt.I<AuthService>().currentUser?.role ==
                                    UserRole.teacher &&
                                GetIt.I<AuthService>()
                                        .currentUser
                                        ?.linkedTeacherId ==
                                    course.teacherId))
                        ? () => _editGrade(grade)
                        : null,
                    onDelete:
                        (GetIt.I<AuthService>().currentUser?.role ==
                                UserRole.admin ||
                            (GetIt.I<AuthService>().currentUser?.role ==
                                    UserRole.teacher &&
                                GetIt.I<AuthService>()
                                        .currentUser
                                        ?.linkedTeacherId ==
                                    course.teacherId))
                        ? () => _deleteGrade(grade)
                        : null,
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton:
            (GetIt.I<AuthService>().currentUser?.role == UserRole.admin ||
                GetIt.I<AuthService>().currentUser?.role == UserRole.teacher)
            ? FloatingActionButton(
                onPressed: _addGrade,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
