import 'package:event_any_where_app/ui/views/auth/signin_screen.dart';
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
      GoRoute(
        path: '/signin',
        builder: (context, state) => SigninScreen(),
      ),
    ],
  );
}
