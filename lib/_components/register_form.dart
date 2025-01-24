import 'package:flutter/material.dart';
import 'package:management_mobile/_components/field_form.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FieldForm(
              label: "Nome", isPassword: false, controller: controllerName),
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
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
                ),
                onPressed: () {},
                child: Text(
                  'REGISTRE-SE',
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
