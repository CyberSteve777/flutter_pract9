import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/students_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/teachers_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/profile_screen.dart';

import 'bloc/auth/auth_bloc.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
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
  }
}
