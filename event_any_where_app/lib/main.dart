import 'package:event_any_where_app/core/constants/app_routes.dart';
import 'package:event_any_where_app/ui/viewmodels/signin_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/signup_viewmodel.dart';
import 'package:event_any_where_app/ui/views/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
