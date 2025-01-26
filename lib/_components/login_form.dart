import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:management_mobile/_components/field_form.dart';
import 'package:management_mobile/controller/user_controller.dart';
import 'package:management_mobile/models/user.dart';
import 'package:management_mobile/screen/equipamentos_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool _onGoingRequest = false;
  UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FieldFormState>();

    return Center(
      child: Column(
        children: [
          FieldForm(
            label: "CPF",
            isPassword: false,
            controller: controllerCpf,
            isNumber: true,
            maxLength: 11,
          ),
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
                  tryLogin();
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

  void tryLogin() async {
    setState(() {
      _onGoingRequest = true; // Define o estado de carregamento
    });

    User user = User(
      usu_nome: '',
      usu_cpf: controllerCpf?.text ?? '',
      usu_senha: controllerPassword?.text ?? '',
      usu_tipo: '',
    );

    Fluttertoast.showToast(
      msg: "Carregando...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    var result = await userController.tryLogin(user);
    if (result.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Login bem-sucedido!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _onGoingRequest = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EquipamentosScreen(
                idUser: result[0]["id"],
                userTipo: int.parse(result[0]["usu_tipo"]))),
      );
    } else {
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _onGoingRequest = false;
      });

      Fluttertoast.showToast(
        msg: "Erro ao Realizar Login!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
