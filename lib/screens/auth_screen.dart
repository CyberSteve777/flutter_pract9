import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      ctx.read<AuthBloc>().add(
        AuthLoginRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Авторизация')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: BlocListener<AuthBloc, AuthState>(
                listenWhen: (prev, curr) =>
                    prev.isAuthenticated != curr.isAuthenticated ||
                    prev.error != curr.error,
                listener: (context, state) {
                  if (state.isAuthenticated) {
                    context.go('/');
                  } else if (state.error != null) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error!),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Электронная почта',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Введите почту' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Пароль'),
                        obscureText: true,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Введите пароль' : null,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () => _login(context),
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Войти'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
