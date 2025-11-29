import 'package:flutter/material.dart';
import 'package:pract9/bloc/courses/courses_bloc.dart';
import 'package:pract9/bloc/grades/grades_bloc.dart';
import 'package:pract9/bloc/home/home_bloc.dart';
import 'package:pract9/bloc/profile/profile_bloc.dart';
import 'package:pract9/bloc/students/students_bloc.dart';
import 'package:pract9/bloc/teachers/teachers_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/data_service.dart';
import 'services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'routes.dart';

void main() {
  GetIt.I.registerSingleton<DataService>(DataService());
  GetIt.I.registerSingleton<AuthService>(AuthService());
  runApp(const EducationalSystemApp());
}

class EducationalSystemApp extends StatelessWidget {
  const EducationalSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          BlocProvider<CoursesBloc>(create: (_) => CoursesBloc()),
          BlocProvider<GradesBloc>(create: (_) => GradesBloc()),
          BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
          BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
          BlocProvider<StudentsBloc>(create: (_) => StudentsBloc()),
          BlocProvider<TeachersBloc>(create: (_) => TeachersBloc()),
        ],
        child: MaterialApp.router(
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
          routerConfig: AppRouter.createRouter(),
        ),
    );
  }
}
