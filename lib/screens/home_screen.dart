import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/home_bloc.dart';
import '../services/auth_service.dart';
import '../utils/ru_plural.dart';
import '../models/models.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();
    return BlocProvider(
      create: (_) => HomeBloc()..add(HomeLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Образовательная система'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authService.logout();
                context.go('/login');
              },
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return _buildDashboard(context, state, authService);
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    String subtitle,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    HomeState state,
    AuthService authService,
  ) {
    final role = state.role;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            'Профиль',
            Icons.person_outline,
            Colors.teal,
                () => context.push('/profile'),
            state.email ?? 'Редактировать данные',
          ),
          _buildMenuCard(
            context,
            'Студенты',
            Icons.people,
            Colors.blue,
            () => context.push('/students'),
            formatCount(
              state.studentsCount,
              'студент',
              'студента',
              'студентов',
            ),
          ),
          _buildMenuCard(
            context,
            'Курсы',
            Icons.school,
            Colors.green,
            () => context.push('/courses'),
            formatCount(state.coursesCount, 'курс', 'курса', 'курсов'),
          ),
          if (role == UserRole.admin)
            _buildMenuCard(
              context,
              'Преподаватели',
              Icons.person,
              Colors.orange,
              () => context.push('/teachers'),
              formatCount(
                state.teachersCount,
                'преподаватель',
                'преподавателя',
                'преподавателей',
              ),
            ),
          _buildMenuCard(
            context,
            'Оценки',
            Icons.grade,
            Colors.purple,
            () => context.push('/grades'),
            formatCount(state.gradesCount, 'оценка', 'оценки', 'оценок'),
          ),
        ],
      ),
    );
  }
}
