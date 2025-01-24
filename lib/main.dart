import 'package:flutter/material.dart';
import 'package:management_mobile/provider/user_provider.dart';
import 'package:management_mobile/screen/login_screen.dart';
import 'package:management_mobile/screen/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gerenciamento de produtos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/login",
        routes: {
          "/login": (context) => const LoginScreen(),
          "/register": (context) => RegisterScreen(),
          // "/main": (context) => const MainBottomNavigation(),
        },
      );
  }
}
