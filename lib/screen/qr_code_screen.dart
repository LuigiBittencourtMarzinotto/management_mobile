import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:management_mobile/controller/equipamento_controller.dart';
import 'package:management_mobile/controller/equipamentos_users_controller.dart';
import 'package:management_mobile/models/equipamento.dart';
import 'package:management_mobile/screen/equipamentos_screen.dart';

class QrCodeScannerScreen extends StatefulWidget {
  static const String routeName = '/qr_code';
  final int idUser;
  final int userTipo;
  final bool create;
  final String? codigoEquipamento;
  const QrCodeScannerScreen({
    Key? key,
    required this.idUser,
    required this.userTipo,
    required this.create,
    this.codigoEquipamento,
  }) : super(key: key);

  @override
  _QrCodeScannerScreenState createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey _qrKey = GlobalKey();
  String qrText = "Nenhum código escaneado ainda";
  bool isScanning = true;
  bool alertDisplayed = false; // Controle para alertas
  String codigo = "0";
  String nome = "";
  String descricao = "";
  EquipamentoController equipamentoController = EquipamentoController();
  @override
  void dispose() {
    super.dispose();
  }

  void _onQRViewCreated(String? code) {
    if (!isScanning) {
      debugPrint("Leitor já está em execução.");
      return;
    }

    setState(() {
      isScanning = false;
      qrText = code ?? "Falha ao escanear o código";
      _processQRCode(qrText);
    });
  }

  void _processQRCode(String qrContent) {
    try {
      final Map<String, dynamic> jsonData = json.decode(qrContent);
      setState(() {
        codigo = jsonData['codigo']?.toString() ?? "0";
        nome = jsonData['nome'] ?? "";
        descricao = jsonData['descricao'] ?? "";
      });

      if (nome.isEmpty || codigo == "0") {
        _showInvalidQRCodeAlert();
      }
    } catch (e) {
      _showInvalidQRCodeAlert();
    }
  }

  void _showInvalidQRCodeAlert() {
    if (!alertDisplayed) {
      alertDisplayed = true;

      final snackBar = SnackBar(
        content: const Text(
          "O QR Code lido não contém as informações necessárias para criar um equipamento.",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Fechar",
          textColor: Colors.white,
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(const Duration(seconds: 3), () {
        alertDisplayed = false;
        _resetScanner();
      });
    }
  }

  void _resetScanner() {
    if (!isScanning) {
      setState(() {
        isScanning = true;
        qrText = "Nenhum código escaneado ainda";
        codigo = "0";
        nome = "";
        descricao = "";
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Formatação manual
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');

    return "$year-$month-$day $hour:$minute:$second";
  }

  void _salvarEquipamento() async {
    Equipamento equipamento = Equipamento(
      eq_nome: nome,
      eq_codigo: codigo,
      eq_descricao: descricao,
      data_cadastro: _formatDateTime(DateTime.now()),
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

    var result = await equipamentoController.setEquipamento(equipamento);
    if (result != false) {
      _resetScanner();

      Fluttertoast.showToast(
        msg: "Cadastrado com sucesso!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await Future.delayed(Duration(seconds: 3));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EquipamentosScreen(
            idUser: widget.idUser,
            userTipo: widget.userTipo,
          ),
        ),
      );
    } else {
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeScannerScreen(
            idUser: widget.idUser,
            userTipo: widget.userTipo,
            create: widget.create,
          ),
        ),
      );
      Fluttertoast.showToast(
        msg: "Código de equipamento já cadastrado!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _validarInventario() async {
    EquipamentosUsersController equipamentosUsersController =
        EquipamentosUsersController();
    Equipamento equipamento = Equipamento(
      eq_nome: nome,
      eq_codigo: codigo,
      eq_descricao: descricao,
      data_cadastro: "",
      data_inventario: _formatDateTime(DateTime.now()),
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
    if (equipamento.eq_codigo == widget.codigoEquipamento) {
          var dadosEquipamento =
        await equipamentoController.getEquipamentosByCodigo(equipamento);
        equipamento.id = dadosEquipamento[0].id;
      var result = await equipamentosUsersController
          .updateVinculoEquipamentoUser(equipamento);
      if (result != false) {
        _resetScanner();
        Fluttertoast.showToast(
          msg: "Validado com sucesso!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await Future.delayed(Duration(seconds: 3));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EquipamentosScreen(
              idUser: widget.idUser,
              userTipo: widget.userTipo,
            ),
          ),
        );
      } else {
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeScannerScreen(
              idUser: widget.idUser,
              userTipo: widget.userTipo,
              create: widget.create,
            ),
          ),
        );
        Fluttertoast.showToast(
          msg: "Erro ao validar inventario!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeScannerScreen(
            idUser: widget.idUser,
            userTipo: widget.userTipo,
            create: widget.create,
          ),
        ),
      );
      Fluttertoast.showToast(
        msg: "Código de equipamento não corresponde!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool create = widget.create ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitor de QR Code"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                if (isScanning)
                  QRBarScannerCamera(
                    key: _qrKey,
                    onError: (context, error) => Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    qrCodeCallback: _onQRViewCreated,
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !alertDisplayed
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 100,
                            )
                          : Icon(
                              Icons.warning,
                              color: const Color.fromARGB(255, 255, 0, 0),
                              size: 100,
                            ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Código: $codigo\nNome: $nome\nDescrição: $descricao",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isScanning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              create ? _salvarEquipamento : _validarInventario,
                          child: Text(
                            create ? "Adicionar" : "Validar",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _resetScanner,
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
