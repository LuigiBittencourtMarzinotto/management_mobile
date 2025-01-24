import 'package:flutter/material.dart';
import 'package:management_mobile/_components/login_form.dart';
import 'package:management_mobile/_components/register_form.dart';
import 'package:management_mobile/screen/register_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
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
                    Text("CADASTRO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    RegisterForm()
                  ]))),
          const SizedBox(
            height: 30,
          ), ])
      ]),
    );
  }
}
