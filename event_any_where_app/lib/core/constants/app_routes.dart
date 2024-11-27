import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/views/auth/signup_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/signin',
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
    ],
  );
}
