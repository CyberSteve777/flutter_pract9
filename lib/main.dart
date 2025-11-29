import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/students_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/teachers_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/profile_screen.dart';
import 'services/data_service.dart';
import 'services/auth_service.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.I.registerSingleton<DataService>(DataService());
  GetIt.I.registerSingleton<AuthService>(AuthService());
  runApp(const EducationalSystemApp());
}

class EducationalSystemApp extends StatelessWidget {
  const EducationalSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const AuthorizationScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/students',
          builder: (context, state) => const StudentsScreen(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CoursesScreen(),
        ),
        GoRoute(
          path: '/teachers',
          builder: (context, state) => const TeachersScreen(),
        ),
        GoRoute(
          path: '/grades',
          builder: (context, state) => const GradesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Образовательная система',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
