import 'package:flutter/material.dart';
import 'package:management_mobile/_components/login_form.dart';
import 'package:management_mobile/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).size.height / 8, 0, 0),
          alignment: Alignment.topCenter,
          child: Image.asset(
            './assets/images/JAGUA_LOGO_PMS.png',
            width: 140,
          ),
        ),
        ListView(children: <Widget>[
          Card(
              margin: EdgeInsets.fromLTRB(
                  32, MediaQuery.of(context).size.height / 3.0 - 50, 32, 0),
              color: Colors.white,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(children: <Widget>[
                    Text("LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    LoginForm()
                  ]))),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Não tem conta uma conta? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text(
                  'CLIQUE AQUI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ])
      ]),
    );
  }
}
