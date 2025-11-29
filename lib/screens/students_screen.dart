import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import 'package:get_it/get_it.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {

  void _addStudent() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить студента'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ФИО'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Электронная почта'),
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
                  emailController.text.isNotEmpty) {
                final newStudent = Student(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  enrolledCourses: [],
                );
                context.read<StudentsBloc>().add(StudentAdded(newStudent));
                context.pop();
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _editStudent(Student student) {
    final nameController = TextEditingController(text: student.name);
    final emailController = TextEditingController(text: student.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать студента'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ФИО'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Электронная почта'),
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
                  emailController.text.isNotEmpty) {
                final updatedStudent = Student(
                  id: student.id,
                  name: nameController.text,
                  email: emailController.text,
                  enrolledCourses: student.enrolledCourses,
                );
                context.read<StudentsBloc>().add(StudentUpdated(updatedStudent));
                context.pop();
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить студента'),
        content: Text('Вы уверены, что хотите удалить ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<StudentsBloc>().add(StudentDeleted(student.id));
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
      create: (_) => StudentsBloc()..add(StudentsLoad()),
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Студенты'),
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
      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.students.length,
        itemBuilder: (context, index) {
          final student = state.students[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: StudentCard(
              student: student,
              onEdit: GetIt.I<AuthService>().currentUser?.role == UserRole.admin
                  ? () => _editStudent(student)
                  : null,
              onDelete: GetIt.I<AuthService>().currentUser?.role == UserRole.admin
                  ? () => _deleteStudent(student)
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
              onPressed: _addStudent,
              child: const Icon(Icons.add),
            )
          : null,
    ),
    );
  }
}
