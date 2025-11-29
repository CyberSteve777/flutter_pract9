import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/teachers/teachers_bloc.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import 'package:get_it/get_it.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  void _addTeacher() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final departmentController = TextEditingController();
    final positionController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить преподавателя'),
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
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(labelText: 'Кафедра'),
            ),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Должность'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Телефон'),
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
                final newTeacher = Teacher(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  department: departmentController.text,
                  position: positionController.text,
                  phoneNumber: phoneController.text,
                  subjects: [],
                );
                context.read<TeachersBloc>().add(TeacherAdded(newTeacher));
                context.pop();
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _editTeacher(Teacher teacher) {
    final nameController = TextEditingController(text: teacher.name);
    final emailController = TextEditingController(text: teacher.email);
    final departmentController = TextEditingController(
      text: teacher.department,
    );
    final positionController = TextEditingController(text: teacher.position);
    final phoneController = TextEditingController(text: teacher.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать преподавателя'),
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
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(labelText: 'Кафедра'),
            ),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Должность'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Телефон'),
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
                final updatedTeacher = Teacher(
                  id: teacher.id,
                  name: nameController.text,
                  email: emailController.text,
                  department: departmentController.text,
                  position: positionController.text,
                  phoneNumber: phoneController.text,
                  subjects: teacher.subjects,
                );
                context.read<TeachersBloc>().add(
                  TeacherUpdated(updatedTeacher),
                );
                context.pop();
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteTeacher(Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить преподавателя'),
        content: Text('Вы уверены, что хотите удалить ${teacher.name}?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<TeachersBloc>().add(TeacherDeleted(teacher.id));
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
    final role = GetIt.I<AuthService>().currentUser?.role;
    if (role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Преподаватели'),
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
        body: const Center(child: Text('Нет доступа')),
      );
    }

    return BlocProvider(
      create: (_) => TeachersBloc()..add(TeachersLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Преподаватели'),
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
        body: BlocBuilder<TeachersBloc, TeachersState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.teachers.length,
              itemBuilder: (context, index) {
                final teacher = state.teachers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TeacherCard(
                    teacher: teacher,
                    onEdit: () => _editTeacher(teacher),
                    onDelete: () => _deleteTeacher(teacher),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTeacher,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
