import 'package:flutter/material.dart';
import 'package:management_mobile/_components/field_form.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FieldFormState>();

    return Center(
      child: Column(
        children: [
          FieldForm(
              label: "E-mail", isPassword: false, controller: controllerEmail),
          FieldForm(
              label: "Senha", isPassword: true, controller: controllerPassword),
          Container(
              margin: EdgeInsets.all(10),
              width: double.maxFinite,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
                ),
                onPressed: () {},
                child: Text(
                  'ENTRAR',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
