import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:management_mobile/_components/field_form.dart';
import 'package:management_mobile/controller/user_controller.dart';
import 'package:management_mobile/models/user.dart';
import 'package:management_mobile/screen/equipamentos_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool _onGoingRequest = false;
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FieldForm(
              label: "Nome", isPassword: false, controller: controllerName),
          FieldForm(
              label: "CPF",
              isPassword: false,
              controller: controllerCpf,
              isNumber: true,
              maxLength: 11),
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
                onPressed: () {
                  setState(() {
                    _onGoingRequest = true;
                  });
                  _salvarRespostas();
                },
                child: _onGoingRequest
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
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

  void _salvarRespostas() async {
    User user = User(
      usu_nome: controllerName?.text ?? '',
      usu_cpf: controllerCpf?.text ?? '',
      usu_senha: controllerPassword?.text ?? '',
      usu_tipo: '0',
    );

    Fluttertoast.showToast(
        msg: "Carregando...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    var result = await userController.createUser(user);
    if (result != false) {
      Fluttertoast.showToast(
          msg: "Cadastrado com sucesso!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _onGoingRequest = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EquipamentosScreen(
                  idUser: result,
                  userTipo: 0,
                )),
      );
    } else {
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _onGoingRequest = false;
      });
      Fluttertoast.showToast(
          msg: "CPF já cadastrado!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
