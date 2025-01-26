import 'package:flutter/material.dart';
import 'package:management_mobile/database/dao/user_dao.dart';
import 'package:management_mobile/database/db.dart';
import 'package:management_mobile/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:management_mobile/screen/login_screen.dart';
import 'package:management_mobile/screen/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoadingScreen());

  final Database db = await getDatabase();
  UserDao userDao = UserDao();
  User user = User(
    usu_nome: "admin",
    usu_cpf: "99999999999",
    usu_senha: "admin123",
    usu_tipo: "1"
  );
  await userDao.setUser(user); // Usuário admin

  runApp(const MyApp());
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
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
      },
    );
  }
}
